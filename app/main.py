"""FastAPI service exposing health, information, and Prometheus metrics."""

import asyncio
import logging
import time
from collections.abc import AsyncIterator
from contextlib import asynccontextmanager
from pathlib import Path

from fastapi import FastAPI, Request
from fastapi.responses import PlainTextResponse
from fastapi.staticfiles import StaticFiles
from prometheus_client import (
    CONTENT_TYPE_LATEST,
    CollectorRegistry,
    Counter,
    Gauge,
    Histogram,
    generate_latest,
)

from app.config import Settings
from app.logging_config import configure_logging

LOGGER = logging.getLogger("platform_demo")
STARTED_AT = time.time()
STATIC_DIR = Path(__file__).parent / "static"


def create_app(settings: Settings | None = None) -> FastAPI:
    config = settings or Settings.from_env()
    configure_logging(config.log_level)
    registry = CollectorRegistry()
    requests = Counter(
        "http_requests_total", "HTTP requests", ["method", "path", "status"], registry=registry
    )
    duration = Histogram(
        "http_request_duration_seconds",
        "HTTP request duration in seconds",
        ["method", "path"],
        registry=registry,
    )
    in_progress = Gauge("http_requests_in_progress", "Requests in progress", registry=registry)

    @asynccontextmanager
    async def lifespan(_: FastAPI) -> AsyncIterator[None]:
        LOGGER.info("service_started", extra={"app_name": config.app_name})
        yield
        LOGGER.info("service_stopped", extra={"app_name": config.app_name})

    application = FastAPI(
        title=config.app_name,
        version=config.app_version,
        docs_url=None,
        redoc_url=None,
        lifespan=lifespan,
    )

    @application.middleware("http")
    async def observe_request(request: Request, call_next):
        started = time.perf_counter()
        route = request.url.path
        in_progress.inc()
        status = 500
        try:
            response = await call_next(request)
            status = response.status_code
            response.headers["X-Content-Type-Options"] = "nosniff"
            response.headers["X-Frame-Options"] = "DENY"
            response.headers["Cache-Control"] = "no-store"
            return response
        finally:
            elapsed = time.perf_counter() - started
            in_progress.dec()
            if route not in {"/", "/health", "/ready", "/metrics", "/api/v1/info"}:
                route = "unmatched"
            requests.labels(request.method, route, str(status)).inc()
            duration.labels(request.method, route).observe(elapsed)
            LOGGER.info(
                "http_request",
                extra={
                    "method": request.method,
                    "path": route,
                    "status_code": status,
                    "duration_seconds": round(elapsed, 6),
                },
            )

    @application.get("/health")
    async def health() -> dict[str, str | float]:
        return {"status": "UP", "uptime_seconds": round(time.time() - STARTED_AT, 3)}

    @application.get("/ready")
    async def ready():
        from fastapi.responses import JSONResponse

        if config.simulate_dependency_failure:
            return JSONResponse(status_code=503, content={"status": "NOT_READY"})
        return {"status": "READY"}

    @application.get("/api/v1/info")
    async def info() -> dict[str, str]:
        return {
            "name": config.app_name,
            "version": config.app_version,
            "environment": config.app_env,
            "revision": config.git_commit,
        }

    @application.get("/metrics", include_in_schema=False)
    async def metrics():
        if not config.metrics_enabled:
            from fastapi.responses import JSONResponse

            return JSONResponse(status_code=404, content={"detail": "metrics are disabled"})
        return PlainTextResponse(generate_latest(registry), media_type=CONTENT_TYPE_LATEST)

    @application.get("/_internal/simulate-delay", include_in_schema=False)
    async def simulate_delay():
        if config.simulate_slow_response_ms:
            await asyncio.sleep(config.simulate_slow_response_ms / 1000)
        return {"status": "completed"}

    application.mount("/", StaticFiles(directory=STATIC_DIR, html=True), name="frontend")
    return application


app = create_app()

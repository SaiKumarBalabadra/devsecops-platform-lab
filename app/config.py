"""Environment-backed application settings."""

import os
from dataclasses import dataclass


def _bool(name: str, default: bool) -> bool:
    value = os.getenv(name, str(default)).strip().lower()
    if value not in {"true", "false", "1", "0", "yes", "no"}:
        raise ValueError(f"{name} must be a boolean")
    return value in {"true", "1", "yes"}


@dataclass(frozen=True)
class Settings:
    app_name: str = "platform-demo"
    app_env: str = "development"
    app_version: str = "0.1.0"
    git_commit: str = "local"
    log_level: str = "INFO"
    metrics_enabled: bool = True
    simulate_dependency_failure: bool = False
    simulate_slow_response_ms: int = 0

    @classmethod
    def from_env(cls) -> "Settings":
        delay = int(os.getenv("SIMULATE_SLOW_RESPONSE_MS", "0"))
        if delay < 0 or delay > 10_000:
            raise ValueError("SIMULATE_SLOW_RESPONSE_MS must be between 0 and 10000")
        log_level = os.getenv("LOG_LEVEL", "INFO").upper()
        if log_level not in {"DEBUG", "INFO", "WARNING", "ERROR", "CRITICAL"}:
            raise ValueError("LOG_LEVEL must be a standard Python log level")
        return cls(
            app_name=os.getenv("APP_NAME", "platform-demo"),
            app_env=os.getenv("APP_ENV", "development").lower(),
            app_version=os.getenv("APP_VERSION", "0.1.0"),
            git_commit=os.getenv("GIT_COMMIT", "local"),
            log_level=log_level,
            metrics_enabled=_bool("METRICS_ENABLED", True),
            simulate_dependency_failure=_bool("SIMULATE_DEPENDENCY_FAILURE", False),
            simulate_slow_response_ms=delay,
        )

FROM python:3.12.15-alpine3.23@sha256:3d0ca66b723a0ff2a7a6e424cc2d01443e1b7c75ffcc110145f75d0f4daf6d63 AS builder
ENV VIRTUAL_ENV=/opt/venv PATH="/opt/venv/bin:$PATH" PYTHONDONTWRITEBYTECODE=1
WORKDIR /build
RUN python -m venv "$VIRTUAL_ENV"
COPY requirements.txt .
RUN pip install --no-cache-dir --upgrade pip==25.3 \
    && pip install --no-cache-dir -r requirements.txt

FROM python:3.12.15-alpine3.23@sha256:3d0ca66b723a0ff2a7a6e424cc2d01443e1b7c75ffcc110145f75d0f4daf6d63 AS runtime
ENV VIRTUAL_ENV=/opt/venv PATH="/opt/venv/bin:$PATH" PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 PORT=8000
WORKDIR /app
RUN apk upgrade --no-cache \
    && addgroup -S -g 10001 app \
    && adduser -S -D -H -u 10001 -G app -s /sbin/nologin app \
    && mkdir -p /tmp/app \
    && chown 10001:10001 /tmp/app
COPY --from=builder /opt/venv /opt/venv
COPY --chown=10001:10001 app ./app
USER 10001:10001
EXPOSE 8000
HEALTHCHECK --interval=30s --timeout=3s --start-period=10s --retries=3 \
    CMD python -c "import urllib.request; urllib.request.urlopen('http://127.0.0.1:8000/health', timeout=2)" || exit 1
ENTRYPOINT ["python", "-m", "uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000", "--proxy-headers", "--forwarded-allow-ips="]

from fastapi.testclient import TestClient

from app.config import Settings
from app.main import create_app


def client(**overrides):
    return TestClient(create_app(Settings(**overrides)))


def test_health_and_info():
    with client() as test_client:
        response = test_client.get("/health")
        assert response.status_code == 200
        assert response.json()["status"] == "UP"
        info = test_client.get("/api/v1/info").json()
        assert info["name"] == "platform-demo"
        assert info["version"] == "0.1.0"


def test_readiness_reports_dependency_failure():
    with client(simulate_dependency_failure=True) as test_client:
        response = test_client.get("/ready")
        assert response.status_code == 503
        assert response.json()["status"] == "NOT_READY"


def test_metrics_expose_request_counters():
    with client() as test_client:
        test_client.get("/health")
        response = test_client.get("/metrics")
        assert response.status_code == 200
        assert 'http_requests_total{method="GET",path="/health",status="200"}' in response.text


def test_metrics_can_be_disabled():
    with client(metrics_enabled=False) as test_client:
        assert test_client.get("/metrics").status_code == 404


def test_frontend_is_served():
    with client() as test_client:
        response = test_client.get("/")
        assert response.status_code == 200
        assert "Platform Service" in response.text


def test_settings_reject_invalid_delay(monkeypatch):
    monkeypatch.setenv("SIMULATE_SLOW_RESPONSE_MS", "-1")
    try:
        Settings.from_env()
    except ValueError as error:
        assert "between 0 and 10000" in str(error)
    else:
        raise AssertionError("invalid delay should fail configuration")

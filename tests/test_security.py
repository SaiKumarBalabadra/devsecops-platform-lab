import json
import logging
from pathlib import Path

from app.logging_config import JSONFormatter

ROOT = Path(__file__).parents[1]


def test_json_logs_include_safe_context_and_redact_secret_keys():
    record = logging.LogRecord(
        "security", logging.INFO, "test.py", 1, "request handled", (), None
    )
    record.status_code = 200
    record.access_token = "do-not-log-this"
    output = json.loads(JSONFormatter().format(record))
    assert output["status_code"] == 200
    assert output["access_token"] == "[REDACTED]"
    assert "do-not-log-this" not in json.dumps(output)


def test_container_and_deployment_security_defaults():
    dockerfile = (ROOT / "docker/Dockerfile").read_text()
    deployment = (
        ROOT / "kubernetes/helm/devsecops-platform/templates/deployment.yaml"
    ).read_text()
    service_account = (
        ROOT / "kubernetes/helm/devsecops-platform/templates/serviceaccount.yaml"
    ).read_text()
    assert "USER 10001:10001" in dockerfile
    assert "runAsNonRoot: true" in deployment
    assert "readOnlyRootFilesystem: true" in deployment
    assert "allowPrivilegeEscalation: false" in deployment
    assert "automountServiceAccountToken: false" in service_account


def test_release_image_defaults_to_an_explicit_version():
    values = (ROOT / "kubernetes/helm/devsecops-platform/values.yaml").read_text()
    assert 'tag: "0.1.0"' in values
    assert "tag: latest" not in values

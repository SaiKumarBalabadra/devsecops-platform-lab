.PHONY: help install test lint security build up down validate deploy-local

help:
	@printf '%s\n' \
	  'install       Create .venv and install pinned Python dependencies' \
	  'test          Run pytest' \
	  'lint          Run Ruff checks' \
	  'security      Scan source and dependencies with Trivy' \
	  'build         Build the local application image' \
	  'up / down     Start or stop the local Compose service' \
	  'validate      Run tests, lint, Helm, Terraform and YAML checks available locally' \
	  'deploy-local  Install/upgrade the Helm release in the current Kubernetes context'

install:
	python3 -m venv .venv
	.venv/bin/pip install -r requirements-dev.txt

test:
	.venv/bin/pytest

lint:
	.venv/bin/ruff check app tests

security:
	bash scripts/scan-security.sh

build:
	docker compose build app

up:
	docker compose up --build -d

down:
	docker compose down

validate: test lint
	helm lint kubernetes/helm/devsecops-platform -f kubernetes/helm/devsecops-platform/values-dev.yaml
	terraform fmt -check -recursive terraform
	bash scripts/validate-manifests.sh

deploy-local:
	helm upgrade --install platform-demo kubernetes/helm/devsecops-platform \
	  --namespace platform-demo --create-namespace \
	  -f kubernetes/helm/devsecops-platform/values-dev.yaml

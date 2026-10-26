#!/usr/bin/env bash
set -euo pipefail

environment="${1:-}"
image_tag="${2:-}"
case "$environment" in
  dev|staging|prod) ;;
  *) echo "usage: $0 {dev|staging|prod} IMMUTABLE_IMAGE_TAG" >&2; exit 2 ;;
esac
if [[ ! "$image_tag" =~ ^[A-Za-z0-9_][A-Za-z0-9_.-]{0,127}$ ]]; then
  echo "image tag must be a non-empty immutable-style tag (for example a commit SHA)" >&2
  exit 2
fi

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
values="$repo_root/kubernetes/helm/devsecops-platform/values-${environment}.yaml"
if [[ ! -f "$values" ]]; then
  echo "environment values file not found: $values" >&2
  exit 1
fi
if ! grep -qE '^  tag: ' "$values"; then
  echo "image.tag entry not found in $values" >&2
  exit 1
fi
sed -i -E "s/^  tag: .*/  tag: \"${image_tag}\"/" "$values"
if ! grep -qE "^  tag: \"${image_tag}\"$" "$values"; then
  echo "failed to update image.tag in $values" >&2
  exit 1
fi
echo "Updated $values. Review and commit this GitOps change to promote."

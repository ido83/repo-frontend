#!/usr/bin/env bash
# up.sh  -  Universal compose runner for repo-frontend

set -euo pipefail

ENV="${1:-dev}"
shift || true

BASE_FILE="docker-compose.yml"
OVERRIDE_FILE="docker-compose.${ENV}.yml"

if [[ ! -f "../infra-base/compose/base-app.yml" ]]; then
  echo "Missing shared compose file: ../infra-base/compose/base-app.yml"
  exit 1
fi

COMPOSE_FILES=("-f" "$BASE_FILE")

if [[ -f "$OVERRIDE_FILE" ]]; then
  COMPOSE_FILES+=("-f" "$OVERRIDE_FILE")
  echo "Loading override: $OVERRIDE_FILE"
else
  echo "No override file found for ENV=$ENV, using base only."
fi

echo "Starting stack (ENV=$ENV)..."
docker compose "${COMPOSE_FILES[@]}" up "$@"

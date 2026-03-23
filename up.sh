#!/usr/bin/env bash
# up.sh  -  Universal compose runner

set -euo pipefail

ENV="${1:-dev}"
shift || true

BASE_FILE="docker-compose.yml"
OVERRIDE_FILE="docker-compose.${ENV}.yml"
INFRA_BASE_DIR="../infra-base"
ENV_FILES=(
  "--env-file" "$INFRA_BASE_DIR/env/.env.base"
  "--env-file" "$INFRA_BASE_DIR/env/.env.networking"
)

if [[ -f "$INFRA_BASE_DIR/env/.env.secrets" ]]; then
  ENV_FILES+=("--env-file" "$INFRA_BASE_DIR/env/.env.secrets")
fi

if [[ ! -f "$INFRA_BASE_DIR/compose/base-app.yml" ]]; then
  echo "Missing shared compose file: $INFRA_BASE_DIR/compose/base-app.yml"
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
docker compose "${ENV_FILES[@]}" "${COMPOSE_FILES[@]}" up "$@"

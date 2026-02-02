#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SCRIPT_PATH="$SCRIPT_DIR/$(basename "$0")"
ENV_FILE="${ENV_FILE:-$SCRIPT_DIR/.env}"
LOG_FILE="${LOG_FILE:-$SCRIPT_DIR/sg-ip-updater.log}"
CRON_SCHEDULE="${CRON_SCHEDULE:-* * * * *}"

usage() {
  cat <<EOF
Usage:
  $0                 Run once (cron-friendly)
  $0 --install       Install cron job (runs every minute)
  $0 --uninstall     Remove cron job
EOF
}

ensure_commands() {
  command -v curl >/dev/null 2>&1 || { echo "[ERROR] curl not found"; exit 1; }
  command -v aws  >/dev/null 2>&1 || { echo "[ERROR] aws CLI not found"; exit 1; }
}

load_env() {
  if [[ ! -f "$ENV_FILE" ]]; then
    echo "[ERROR] .env file not found at: $ENV_FILE" >&2
    exit 1
  fi

  set -a
  # shellcheck disable=SC1090
  source "$ENV_FILE"
  set +a

  : "${AWS_REGION:?Missing AWS_REGION}"
  : "${STATE_FILE:?Missing STATE_FILE}"
  : "${LAMBDA_FUNCTION_NAME:?Missing LAMBDA_FUNCTION_NAME}"

  export AWS_DEFAULT_REGION="$AWS_REGION"
}

get_public_ip() {
  local ip
  ip="$(curl -fsS https://checkip.amazonaws.com | tr -d '[:space:]')"

  if [[ ! "$ip" =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]]; then
    echo "[ERROR] Invalid IP: '$ip'" >&2
    exit 1
  fi

  echo "$ip"
}

install_cron() {
  ensure_commands
  load_env

  mkdir -p "$(dirname "$STATE_FILE")"

  chmod 600 "$ENV_FILE" || true
  touch "$LOG_FILE"
  chmod 600 "$LOG_FILE" || true

  local marker="# sg-ip-updater (managed)"
  local cron_line="${CRON_SCHEDULE} /usr/bin/env ENV_FILE=${ENV_FILE} LOG_FILE=${LOG_FILE} /bin/bash ${SCRIPT_PATH} >> ${LOG_FILE} 2>&1 ${marker}"

  (crontab -l 2>/dev/null || true) \
    | grep -v "sg-ip-updater (managed)" \
    | grep -v "${SCRIPT_PATH}" \
    | { cat; echo "$cron_line"; } \
    | crontab -

  echo "Installed cron job:"
  echo "$cron_line"
}

uninstall_cron() {
  (crontab -l 2>/dev/null || true) \
    | grep -v "sg-ip-updater (managed)" \
    | crontab -
  echo "Removed cron job."
}

invoke_lambda() {
  local ip="$1"

  # AWS CLI v2 requires this for raw JSON payloads
  aws lambda invoke \
    --function-name "$LAMBDA_FUNCTION_NAME" \
    --cli-binary-format raw-in-base64-out \
    --payload "{\"ip\":\"${ip}\"}" \
    /dev/null >/dev/null
}

run_once() {
  ensure_commands
  load_env

  mkdir -p "$(dirname "$STATE_FILE")"

  local current_ip last_ip
  current_ip="$(get_public_ip)"

  last_ip=""
  if [[ -f "$STATE_FILE" ]]; then
    last_ip="$(tr -d '[:space:]' < "$STATE_FILE" || true)"
  fi

  if [[ -n "$last_ip" && "$last_ip" == "$current_ip" ]]; then
    echo "No change: $current_ip"
    exit 0
  fi

  echo "IP changed: ${last_ip:-<none>} -> $current_ip"
  echo "Invoking Lambda: $LAMBDA_FUNCTION_NAME"

  invoke_lambda "$current_ip"

  echo "$current_ip" > "$STATE_FILE"
  echo "Done. State updated to $current_ip"
}

case "${1:-}" in
  --install)
    install_cron
    ;;
  --uninstall)
    uninstall_cron
    ;;
  -h|--help)
    usage
    ;;
  "")
    run_once
    ;;
  *)
    echo "[ERROR] Unknown argument: $1" >&2
    usage
    exit 1
    ;;
esac

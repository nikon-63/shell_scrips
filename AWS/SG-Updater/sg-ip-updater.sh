#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SCRIPT_PATH="$SCRIPT_DIR/$(basename "$0")"
ENV_FILE="${ENV_FILE:-$SCRIPT_DIR/.env}"
LOG_FILE="${LOG_FILE:-$(cd "$(dirname "$0")" && pwd)/sg-ip-updater.log}"
CRON_SCHEDULE="${CRON_SCHEDULE:-* * * * *}"
MANAGED_MARKER="(managed)"

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
  source "$ENV_FILE"
  set +a

  : "${AWS_REGION:?Missing AWS_REGION}"
  : "${SECURITY_GROUP_ID:?Missing SECURITY_GROUP_ID}"
  : "${STATE_FILE:?Missing STATE_FILE}"
  : "${AWS_ACCESS_KEY_ID:?Missing AWS_ACCESS_KEY_ID}"
  : "${AWS_SECRET_ACCESS_KEY:?Missing AWS_SECRET_ACCESS_KEY}"

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

  aws ec2 authorize-security-group-egress \
    --group-id "$SECURITY_GROUP_ID" \
    --ip-permissions '[
      {"IpProtocol":"-1","IpRanges":[{"CidrIp":"0.0.0.0/0","Description":"Allow all outbound IPv4"}]},
      {"IpProtocol":"-1","Ipv6Ranges":[{"CidrIpv6":"::/0","Description":"Allow all outbound IPv6"}]}
    ]' >/dev/null 2>&1 || true

  if [[ -n "$last_ip" && "$last_ip" == "$current_ip" ]]; then
    echo "No change: $current_ip"
    exit 0
  fi

  echo "IP changed: ${last_ip:-<none>} -> $current_ip"
  echo "Updating SG $SECURITY_GROUP_ID (inbound allow-all from ${current_ip}/32)"

  local managed_cidrs
  managed_cidrs="$(
    aws ec2 describe-security-groups \
      --group-ids "$SECURITY_GROUP_ID" \
      --query "SecurityGroups[0].IpPermissions[?IpProtocol=='-1'].IpRanges[?contains(Description, '${MANAGED_MARKER}')].CidrIp" \
      --output text 2>/dev/null || true
  )"

  if [[ -n "${managed_cidrs// }" ]]; then
    for cidr in $managed_cidrs; do
      if [[ "$cidr" =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}/32$ ]]; then
        aws ec2 revoke-security-group-ingress \
          --group-id "$SECURITY_GROUP_ID" \
          --ip-permissions "[
            {\"IpProtocol\":\"-1\",\"IpRanges\":[{\"CidrIp\":\"${cidr}\"}]}
          ]" >/dev/null 2>&1 || true
        echo "Revoked managed inbound: $cidr"
      fi
    done
  fi

  if [[ -n "$last_ip" ]]; then
    aws ec2 revoke-security-group-ingress \
      --group-id "$SECURITY_GROUP_ID" \
      --ip-permissions "[
        {\"IpProtocol\":\"-1\",\"IpRanges\":[{\"CidrIp\":\"${last_ip}/32\"}]}
      ]" >/dev/null 2>&1 || true
  fi

  aws ec2 authorize-security-group-ingress \
    --group-id "$SECURITY_GROUP_ID" \
    --ip-permissions "[
      {\"IpProtocol\":\"-1\",\"IpRanges\":[{\"CidrIp\":\"${current_ip}/32\",\"Description\":\"Current public IP ${MANAGED_MARKER}\"}]}
    ]" >/dev/null 2>&1 || true

  echo "$current_ip" > "$STATE_FILE"
  echo "Done. Inbound managed rule is now ${current_ip}/32"
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

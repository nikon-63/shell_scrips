#!/bin/bash

LOG_FILE="netcheck.log"
SITES=(
    "https://google.com"
    "https://cloudflare.com"
    "https://github.com"
    "https://amazon.com"
)
CURL_TIMEOUT=5
DIG_TIMEOUT=2


mkdir -p "$(dirname "$LOG_FILE")"
touch "$LOG_FILE"

echo "----- Net check started $(date +"%Y-%m-%dT%H:%M:%S%z") -----" >>"$LOG_FILE"

for site in "${SITES[@]}"; do
    ts=$(date +"%Y-%m-%dT%H:%M:%S%z")
    host=${site#*://}
    dns_ip=$(dig +timeout=$DIG_TIMEOUT +tries=1 +short "$host" | head -n1)
    dns_rc=$?
    if [[ $dns_rc -ne 0 || -z $dns_ip ]]; then
        echo "$ts $site DNS_FAIL" >>"$LOG_FILE"
        continue
    fi

    read -r http_code t_dns t_conn t_start t_total <<<"$(
        curl -m "$CURL_TIMEOUT" -o /dev/null -s \
            -w "%{http_code} %{time_namelookup} %{time_connect} %{time_starttransfer} %{time_total}" \
            "$site"
    )"
    curl_rc=$?

    if [[ $curl_rc -ne 0 ]]; then
        echo "$ts $site CURL_FAIL rc=$curl_rc" >>"$LOG_FILE"
        continue
    fi

    echo "$ts $site OK HTTP=$http_code dns=${t_dns}s conn=${t_conn}s start=${t_start}s total=${t_total}s" \
        >>"$LOG_FILE"
done

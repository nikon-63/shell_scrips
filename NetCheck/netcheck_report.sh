#!/bin/bash

LOG_FILE="netcheck.log"

[[ -f $LOG_FILE ]] || { echo "Log file $LOG_FILE not found." >&2; exit 1; }

awk '
BEGIN {
    red="\033[31m"; green="\033[32m"; yellow="\033[33m"; reset="\033[0m";
}
# Detect new log sessions for a nicer header
/^----- Net check started/ { latest_session = substr($0, 28); next }

{
    site  = $2;
    label = $3;

    if (label=="OK") {
        ok[site]++
    } else {
        fail[site]++
        printf red"%-20s %-24s %s\n"reset, site, $1, $0
    }
}
END {
    printf "\n%sSummary (since %s)%s\n", yellow, latest_session, reset;
    printf "%-20s %-6s %-6s\n", "Site", "OK", "FAIL";
    for (s in ok) {
        printf "%-20s %-6d %-6d\n", s, ok[s], fail[s];
    }
}' "$LOG_FILE"

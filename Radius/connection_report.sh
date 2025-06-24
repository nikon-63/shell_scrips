#!/bin/bash

# Command to make log file
# printf "\n[%s]\n" "$(date '+%F %T')" >> output.log; ./connection_test.sh -h <HOST> -p <PORT> -s <SECRET> -u <USER> -P '<PASSWORD>' >> output.log 2>&1

# Example cron job
# */2 * * * * cd <DIRECTORY> && printf "\n[%s]\n" "$(date '+%F %T')" >> output.log && ./connection_test.sh -h <HOST> -p <PORT> -s <SECRET> -u <USER> -P '<PASSWORD>' >> output.log 2>&1

LOG="output.log"
[[ -f $LOG ]] || { echo "Log not found: $LOG"; exit 1; }

awk '
  BEGIN { RS="\\n\\["; FS="\\n" }
  # RS splits on a newline followed by '[', but we re-add it below
  NR>1 {
    # reconstruct timestamp
    ts = "[" substr($1, 1, index($1,"]") )
    # look for Reject
    has_reject = 0
    for (i=2;i<=NF;i++) {
      if ($i ~ /Received Access-Reject/) has_reject = 1
      if ($i ~ /Testing/) test_line = $i
    }
    if (has_reject) {
      print ts " " test_line " -> FAILURE"
    }
  }
' "$LOG"

#!/usr/bin/env bash
# Bulk send from a CSV file (first line: phone,content[,scheduled_at]). Usage: bash bulk-send.sh messages.csv
set -euo pipefail
CSV="${1:?csv file required}"

curl -sS -X POST "https://dev.resala.ly/api/v1/messages/bulk-send" \
  -H "Authorization: Bearer ${RESALA_API_KEY:?set RESALA_API_KEY}" \
  -F "csv=@${CSV}"
echo

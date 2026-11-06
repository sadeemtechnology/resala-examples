#!/usr/bin/env bash
# Send an approved template. Usage: bash send-template.sh TEMPLATE_ID 218910001234
set -euo pipefail
TEMPLATE_ID="${1:?template id required}"
PHONE="${2:?phone required}"

curl -sS -X POST "https://dev.resala.ly/api/v1/messages/send-template?sms_template_id=${TEMPLATE_ID}" \
  -H "Authorization: Bearer ${RESALA_API_KEY:?set RESALA_API_KEY}" \
  -H "Content-Type: application/json" \
  -d "{\"records\":[{\"phone\":\"${PHONE}\",\"\$1\":\"Resala\",\"\$2\":\"Ahmed\"}]}"
echo

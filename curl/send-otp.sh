#!/usr/bin/env bash
# Send an OTP code with Resala. Usage: RESALA_API_KEY=... bash send-otp.sh 218910001234 [MyApp]
set -euo pipefail
PHONE="${1:?phone required, e.g. 218910001234}"
SERVICE="${2:-MyApp}"

curl -sS -X POST "https://dev.resala.ly/api/v1/pins?service_name=${SERVICE}" \
  -H "Authorization: Bearer ${RESALA_API_KEY:?set RESALA_API_KEY}" \
  -H "Content-Type: application/json" \
  -d "{\"phone\":\"${PHONE}\"}"
echo

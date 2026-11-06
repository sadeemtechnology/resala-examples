#!/usr/bin/env bash
# Latest 20 sent codes and messages with their delivery status.
set -euo pipefail
curl -sS "https://dev.resala.ly/api/v1/sent-view?filters=source:message|pin&paginate=20&sorts=-created_at" \
  -H "Authorization: Bearer ${RESALA_API_KEY:?set RESALA_API_KEY}"
echo

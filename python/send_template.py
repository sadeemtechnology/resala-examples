"""Send an approved template to one or more Libyan numbers (uses `requests`).

Usage: RESALA_API_KEY=... python3 send_template.py TEMPLATE_ID 218910001234
"""
import os
import sys

import requests  # pip install requests

template_id = sys.argv[1] if len(sys.argv) > 1 else sys.exit("Usage: send_template.py TEMPLATE_ID PHONE")
phone = sys.argv[2] if len(sys.argv) > 2 else "218910001234"

r = requests.post(
    "https://dev.resala.ly/api/v1/messages/send-template",
    params={"sms_template_id": template_id},
    headers={"Authorization": f"Bearer {os.environ['RESALA_API_KEY']}"},
    json={"records": [{"phone": phone, "$1": "Resala", "$2": "Ahmed"}]},
    timeout=15,
)
data = r.json()
if not r.ok:
    sys.exit(f"{r.status_code} {data['type']}: {data['message']}")
print(f"sent {data['succeeded']}, failed {data['failed']}, cost {data['total_cost']} LYD", data["invalid_numbers"])

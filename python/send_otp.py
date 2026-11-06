"""Send an OTP code with Resala using the standard library only (Python 3.8+).

Usage: RESALA_API_KEY=... python3 send_otp.py 218910001234
"""
import json
import os
import sys
import urllib.error
import urllib.parse
import urllib.request

phone = sys.argv[1] if len(sys.argv) > 1 else "218910001234"
api_key = os.environ.get("RESALA_API_KEY") or sys.exit("Set RESALA_API_KEY")

params = {"service_name": "MyApp"}  # add "test": "" for test mode, "sender": "MyBrand" for a sender name
url = "https://dev.resala.ly/api/v1/pins?" + urllib.parse.urlencode(params)
req = urllib.request.Request(
    url,
    data=json.dumps({"phone": phone}).encode(),
    headers={"Authorization": f"Bearer {api_key}", "Content-Type": "application/json"},
    method="POST",
)

try:
    with urllib.request.urlopen(req, timeout=15) as res:
        data = json.load(res)
except urllib.error.HTTPError as e:
    err = json.load(e)
    # Branch on err["type"] (InsufficientCredit, InputValidation, ...), not on the localized message.
    sys.exit(f"{e.code} {err['type']}: {err['message']} (request_id {err.get('request_id')})")

# Store data["pin"] server-side and compare it with the user's input; enforce your own expiry.
print("sent", data["id"], "pin", data["pin"], "sender", data.get("sender_name"))

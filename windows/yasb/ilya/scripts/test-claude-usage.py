import json
import os
import urllib.error
import urllib.request

cred_path = os.path.join(os.path.expanduser("~"), ".claude", ".credentials.json")

try:
    with open(cred_path, encoding="utf-8") as f:
        cred = json.load(f)
    oauth = cred.get("claudeAiOauth", {})
    token = oauth.get("accessToken")
    expires = oauth.get("expiresAt") or oauth.get("expires_at")
    print(f"token_present: {bool(token)}")
    print(f"token_length: {len(token) if token else 0}")
    print(f"expires: {expires}")
    if not token:
        raise SystemExit("no token")

    req = urllib.request.Request(
        "https://api.anthropic.com/api/oauth/usage",
        headers={
            "Authorization": f"Bearer {token}",
            "anthropic-beta": "oauth-2025-04-20",
        },
    )
    with urllib.request.urlopen(req, timeout=15) as resp:
        data = json.loads(resp.read().decode())
    print("status: ok")
    print(f"five_hour: {data.get('five_hour', {})}")
    print(f"seven_day: {data.get('seven_day', {})}")
except urllib.error.HTTPError as e:
    body = e.read().decode("utf-8", errors="replace")
    print(f"error_type: HTTPError")
    print(f"status: {e.code}")
    print(f"body: {body[:500]}")
except Exception as e:
    print(f"error_type: {type(e).__name__}")
    print(f"error: {e}")

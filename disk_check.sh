#!/usr/bin/env bash
set -Eeuo pipefail

# ====== Configuration ======
# Trigger alert when disk usage >= THRESHOLD (percent)
THRESHOLD=90

# Email settings
TO_EMAIL=("xxx@yyyy.com" "xxx@yyyy.com")
FROM_EMAIL="alert-collections@911memorial.org"

# >>>>>>>>>>>>>>>>>>>>>>>>>>> Use API key from environment (do NOT hardcode it)

# Load SendGrid API key
if [[ -f /etc/sendgrid.env ]]; then
  export $(grep -v '^#' /etc/sendgrid.env | xargs)
fi

if [[ -z "${SENDGRID_API_KEY:-}" ]]; then
  echo "ERROR: SENDGRID_API_KEY not set." >&2
  exit 1
fi



# Get disk usage for the root filesystem
USAGE=$(df -P / | awk 'END{gsub(/%/,"",$5); print $5}')
HOST=$(hostname)

if [[ -z "${USAGE}" || ! "$USAGE" =~ ^[0-9]+$ ]]; then
  echo "ERROR: Could not parse disk usage." >&2
  exit 1
fi

if [[ "$USAGE" -ge "$THRESHOLD" ]]; then
  # Build personalizations array for each recipient
  PERSONALIZATIONS=$(printf '%s\n' "${TO_EMAIL[@]}" | jq -R '{to: [{email: .}], subject: "Disk Usage Alert"}' | jq -s .)

  # Build JSON payload
  JSON=$(cat <<EOF
  {
    "personalizations": $PERSONALIZATIONS,
    "from": {"email": "$FROM_EMAIL"},
    "content": [
      {
        "type": "text/plain",
        "value": "Disk usage is at $USAGE% on $HOST"
      }
    ]
  }
EOF
  )


  # Call SendGrid
  HTTP_CODE=$(
    curl -sS -o /tmp/sendgrid_resp.json -w "%{http_code}" \
      --request POST \
      --url https://api.sendgrid.com/v3/mail/send \
      --header "Authorization: Bearer $SENDGRID_API_KEY" \
      --header "Content-Type: application/json" \
      --data "$JSON" || true
  )

  if [[ "$HTTP_CODE" -ge 200 && "$HTTP_CODE" -lt 300 ]]; then
    echo "Alert sent: $USAGE% on $HOST"
  else
    echo "SendGrid call failed (HTTP $HTTP_CODE). Response:" >&2
    cat /tmp/sendgrid_resp.json >&2
    exit 1
  fi
else
  echo "Usage $USAGE% < threshold $THRESHOLD%. No email sent."
fi

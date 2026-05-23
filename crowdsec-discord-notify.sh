#!/bin/bash

LOG_FILE="/var/log/crowdsec.log"
DISCORD_WEBHOOK="your webhook"
LOG_COUNT=0 # Count all the CrowdSec logs.
echo "Starting: $LOG_FILE"

tail -f "$LOG_FILE" | while read -r line; do
  if echo "$line" | grep -q "module=db" && echo "$line" | grep -q "ban on"; then
    IP=$(echo "$line" | grep -oP 'ban on (Ip|Range) \K[\d./]+')
    COUNTRY=$(echo "$line" | grep -oP 'by ip [\d.]+ \(\K[^)]+')
    # scenario removed
    DURATION=$(echo "$line" | grep -oP '[\w]+(?= ban on)')

    MSG="**CrowdSec Ban Info** \nIP: $IP ($COUNTRY) \nDuração: $DURATION\nRegistros: $LOG_COUNT"

      curl -s -X POST "$DISCORD_WEBHOOK" \
        -H "Content-Type: application/json" \
        -d "{\"content\": \"$MSG\"}"

    ((LOG_COUNT++))
  else
    ((LOG_COUNT++))
  fi
done

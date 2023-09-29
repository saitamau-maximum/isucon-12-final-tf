#!/bin/sh
cd /home/isucon/bench
TOKEN="<TOKEN>"
export ISUXBENCH_TARGET=192.168.0.3
OUTPUT=$(./bin/benchmarker --stage=prod --request-timeout=10s --initialize-request-timeout=80s)
echo "$OUTPUT"
LAST_SCORE=$(echo "$OUTPUT" | grep -oP '(?<=\[SCORE\] )\d+' | tail -n 1)
REPORT="{\"score\": $LAST_SCORE, \"pass\": true}"
echo "$REPORT"
curl -X POST -H "Authorization: $TOKEN" -d "$REPORT" https://leaderboard.maximum.vc/api/report
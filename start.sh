#!/bin/bash
# ═══════════════════════════════════════════════════════
# Predict WorkNet Bot — Start Script
# Run this on VPS after setup
# ═══════════════════════════════════════════════════════

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/.env"

# ── Validate env ──────────────────────────────────
if [ -z "${AWP_WALLET_TOKEN}" ]; then
    echo "ERROR: AWP_WALLET_TOKEN not set in .env"
    echo "Run: awp-wallet unlock --duration 86400 --scope full --raw"
    echo "Then set it in .env"
    exit 1
fi

# ── Proxy support ─────────────────────────────────
if [ -n "${HTTP_PROXY}" ]; then
    export HTTP_PROXY="${HTTP_PROXY}"
    export HTTPS_PROXY="${HTTP_PROXY}"
    export http_proxy="${HTTP_PROXY}"
    export https_proxy="${HTTP_PROXY}"
    echo "Using proxy: ${HTTP_PROXY}"
fi

# ── Kill existing process ─────────────────────────
pkill -f "predict-agent loop" 2>/dev/null || true

# ── Start loop ────────────────────────────────────
export PATH="${HOME}/.local/bin:${PATH}"
export AWP_WALLET_TOKEN
export PREDICT_SERVER_URL="${PREDICT_SERVER_URL:-https://api.agentpredict.work}"

echo "Starting Predict WorkNet Bot..."
echo "Wallet: $(awp-wallet receive | jq -r '.eoaAddress')"
echo "Server: ${PREDICT_SERVER_URL}"
echo "Interval: ${INTERVAL:-120}s"
echo ""

nohup predict-agent loop \
    --interval "${INTERVAL:-120}" \
    --agent-id "${AGENT_ID:-predict-worker}" \
    > predict-agent.log 2>&1 &

echo "PID: $!"
echo "Log: ${SCRIPT_DIR}/predict-agent.log"

sleep 3
tail -n 20 "${SCRIPT_DIR}/predict-agent.log"

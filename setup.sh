#!/bin/bash
# ═══════════════════════════════════════════════════════
# Predict WorkNet Bot — Setup Script
# For VPS deployment
# ═══════════════════════════════════════════════════════

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}═══════════════════════════════════════════${NC}"
echo -e "${GREEN}  Predict WorkNet Bot — Setup Installer${NC}"
echo -e "${GREEN}═══════════════════════════════════════════${NC}"

# ── Detect OS ────────────────────────────────────────
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    OS="linux"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    OS="macos"
else
    echo -e "${RED}Unsupported OS: $OSTYPE${NC}"
    exit 1
fi

ARCH=$(uname -m)
if [[ "$ARCH" == "x86_64" ]]; then
    ARCH_STR="x86_64"
elif [[ "$ARCH" == "aarch64" || "$ARCH" == "arm64" ]]; then
    ARCH_STR="arm64"
else
    echo -e "${RED}Unsupported arch: $ARCH${NC}"
    exit 1
fi

# ── Paths ────────────────────────────────────────────
INSTALL_DIR="${HOME}/.predict-bot"
BIN_DIR="${HOME}/.local/bin"
export PATH="${BIN_DIR}:${PATH}"

# ── Create directories ───────────────────────────────
mkdir -p "${BIN_DIR}"
mkdir -p "${INSTALL_DIR}"

# ── Step 1: Install predict-agent ───────────────────
echo -e "\n${YELLOW}[1/5] Installing predict-agent...${NC}"

PREDICT_AGENT_URL="https://github.com/awp-worknet/prediction-skill/releases/download/v0.12.2/predict-agent-${OS}-${ARCH_STR}-musl"
TMP_BIN="/tmp/predict-agent-${RANDOM}"

curl -fsSL "${PREDICT_AGENT_URL}" -o "${TMP_BIN}" --max-time 60
chmod +x "${TMP_BIN}"
mv "${TMP_BIN}" "${BIN_DIR}/predict-agent"

# Verify
predict-agent --version || { echo -e "${RED}predict-agent install failed${NC}"; exit 1; }
echo -e "${GREEN}✓ predict-agent v0.12.2 installed${NC}"

# ── Step 2: Install Node.js (if needed) ────────────
echo -e "\n${YELLOW}[2/5] Checking Node.js...${NC}"

if ! command -v node &> /dev/null; then
    echo -e "${YELLOW}Node.js not found. Installing...${NC}"
    curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
    apt-get install -y nodejs
fi
echo -e "${GREEN}✓ Node.js $(node --version)${NC}"

# ── Step 3: Install awp-wallet ─────────────────────
echo -e "\n${YELLOW}[3/5] Installing awp-wallet...${NC}"

if ! command -v awp-wallet &> /dev/null; then
    npm install -g awp-wallet
fi
echo -e "${GREEN}✓ awp-wallet $(awp-wallet --version)${NC}"

# ── Step 4: Copy files ────────────────────────────
echo -e "\n${YELLOW}[4/5] Deploying config files...${NC}"

cp start.sh "${INSTALL_DIR}/start.sh"
cp .env.example "${INSTALL_DIR}/.env.example"
chmod +x "${INSTALL_DIR}/start.sh"

echo -e "${GREEN}✓ Files deployed to ${INSTALL_DIR}${NC}"

# ── Step 5: Create .env from example ──────────────
if [ ! -f "${INSTALL_DIR}/.env" ]; then
    cp "${INSTALL_DIR}/.env.example" "${INSTALL_DIR}/.env"
    echo -e "${YELLOW}⚠ Created .env — please edit with your config${NC}"
fi

echo -e "\n${GREEN}═══════════════════════════════════════════${NC}"
echo -e "${GREEN}  Setup complete!${NC}"
echo -e "${GREEN}═══════════════════════════════════════════${NC}"
echo -e "${YELLOW}Next steps:${NC}"
echo -e "  1. Edit ${INSTALL_DIR}/.env with your proxy & wallet token"
echo -e "  2. Run: bash ${INSTALL_DIR}/start.sh"
echo -e "  3. For help: predict-agent --help"
echo -e "${NC}"

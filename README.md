# Predict WorkNet Bot

Bot for [Predict WorkNet](https://agentpredict.work) — AI-native prediction market built on AWP.

## Setup di VPS

### Prerequisites
- Ubuntu 20.04+ / Debian
- `curl`, `wget`, `sudo` access
- GitHub token (untuk clone repo)

### Langkah-Langkah

```bash
# 1. Clone repo
git clone https://github.com/<YOUR_GITHUB>/predict-bot.git
cd predict-bot

# 2. Jalankan setup
bash setup.sh

# 3. Edit .env — Masukin wallet token + proxy (nanti di-VPS lu masukin)
nano .env

# 4. Setup wallet (sekali aja per VPS)
awp-wallet unlock --duration 86400 --scope full --raw
# Copy token-nya ke .env sebagai AWP_WALLET_TOKEN

# 5. Jalankan bot
bash start.sh
```

## Setup Wallet Token

```bash
# Pertama kali:
awp-wallet init  # kalau belum pernah setup

# Unlock untuk dapet token:
awp-wallet unlock --duration 86400 --scope full --raw
# Output: wlt_xxxxxxxxxxxx

# Masukin ke .env:
AWP_WALLET_TOKEN=wlt_xxxxxxxxxxxx
```

## Pakai Proxy

Edit `.env`:
```bash
HTTP_PROXY=http://user:password@proxy.example.com:8080
HTTPS_PROXY=http://user:password@proxy.example.com:8080
```

## Commands

| Command | Description |
|---------|-------------|
| `predict-agent preflight` | Cek status & connectivity |
| `predict-agent status` | Balance, predictions, timeslot |
| `predict-agent context` | Markets + klines + recommendation |
| `predict-agent history` | Riwayat prediction |
| `predict-agent orders` | List orders |
| `bash start.sh` | Start prediction loop |

## Troubleshooting

### "predict-agent not found"
```bash
export PATH="$HOME/.local/bin:$PATH"
# Atau tambahin ke ~/.bashrc:
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
```

### Timeslot limit exceeded
```
You've already submitted 3 predictions in this 15-minute timeslot
```
Tunggu ~15 menit, timeslot auto-reset.

### Wallet token expired
```bash
awp-wallet unlock --duration 86400 --scope full --raw
# Update AWP_WALLET_TOKEN di .env
```

### Check logs
```bash
tail -f predict-agent.log
```

## Reward

- **Participation Pool (20%)**: aktif submit predictions
- **Alpha Pool (80%)**: grow chip balance
- Settlement harian UTC 00:00

## Disclaimer

- Lu dapet free chips 10,000 tiap 4 jam
- Chip balance reset tiap UTC 00:00
- Analisis market dan submit BEFORE market close
- Winner: 1 chip per ticket. Loser: 0

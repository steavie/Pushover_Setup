#!/bin/bash
# install.sh – Richtet Pushover als systemweites push-Kommando ein
# Ausführen mit: sudo bash install.sh
set -euo pipefail

if [ "$(id -u)" -ne 0 ]; then
  echo "Bitte mit sudo ausführen: sudo bash install.sh" >&2
  exit 1
fi

# ── Farben ────────────────────────────────────────────────────────────────────
GREEN='\033[0;32m'; YELLOW='\033[1;33m'; CYAN='\033[0;36m'
BOLD='\033[1m'; RESET='\033[0m'

echo ""
echo -e "${BOLD}${CYAN}════════════════════════════════════════${RESET}"
echo -e "${BOLD}${CYAN}  Pushover Setup                        ${RESET}"
echo -e "${BOLD}${CYAN}════════════════════════════════════════${RESET}"
echo ""
echo -e "${YELLOW}Pushover-Zugangsdaten eingeben:${RESET}"
echo -e "  → https://pushover.net"
echo ""

# ── Zugangsdaten abfragen ─────────────────────────────────────────────────────
read -rp "  App API Token : " APP_TOKEN
read -rp "  User Key      : " USER_KEY
read -rp "  Standard-Titel (Enter = 'Nachricht'): " DEFAULT_TITLE
DEFAULT_TITLE="${DEFAULT_TITLE:-Nachricht}"

echo ""

# ── /etc/pushover.env ─────────────────────────────────────────────────────────
echo "[1/3] Schreibe /etc/pushover.env ..."
cat > /etc/pushover.env <<EOF
PUSHOVER_APP_TOKEN="${APP_TOKEN}"
PUSHOVER_USER_KEY="${USER_KEY}"
PUSHOVER_DEFAULT_TITLE="${DEFAULT_TITLE}"
EOF
chown root:root /etc/pushover.env
chmod 644 /etc/pushover.env   # alle dürfen lesen, nur root schreiben

# ── /usr/local/bin/push ───────────────────────────────────────────────────────
echo "[2/3] Erstelle /usr/local/bin/push ..."
mkdir -p /usr/local/bin
cat > /usr/local/bin/push <<'SCRIPT'
#!/usr/bin/env bash
set -euo pipefail

CONFIG="/etc/pushover.env"
[[ -f "$CONFIG" ]] || { echo "Fehler: $CONFIG nicht gefunden" >&2; exit 1; }
source "$CONFIG"

# Verwendung:
#   push "Nachricht"
#   push "Titel" "Nachricht"
if [[ $# -eq 0 ]]; then
  echo "Verwendung: push \"Nachricht\"" >&2
  echo "        oder: push \"Titel\" \"Nachricht\"" >&2
  exit 2
elif [[ $# -eq 1 ]]; then
  title="${PUSHOVER_DEFAULT_TITLE}"
  msg="$1"
else
  title="$1"
  msg="${@:2}"
fi

response=$(curl -sS \
  -F "token=${PUSHOVER_APP_TOKEN}" \
  -F "user=${PUSHOVER_USER_KEY}" \
  -F "title=${title}" \
  -F "message=${msg}" \
  https://api.pushover.net/1/messages.json)

if echo "$response" | grep -q '"status":1'; then
  echo "✓ Nachricht gesendet"
else
  echo "✗ Fehler: $response" >&2
  exit 1
fi
SCRIPT
chown root:root /usr/local/bin/push
chmod 755 /usr/local/bin/push
xattr -c /usr/local/bin/push 2>/dev/null || true

# ── Test ──────────────────────────────────────────────────────────────────────
echo "[3/3] Sende Testnachricht ..."
if /usr/local/bin/push "Pushover Setup" "Installation erfolgreich auf $(hostname)"; then
  echo ""
  echo -e "${GREEN}${BOLD}✓ Fertig! Pushover ist eingerichtet.${RESET}"
  echo ""
  echo -e "  ${BOLD}Verwendung:${RESET}"
  echo -e "  push \"Irgendein Text\""
  echo -e "  push \"Titel\" \"Nachricht\""
  echo ""
else
  echo ""
  echo "✗ Testnachricht fehlgeschlagen – Token/Key prüfen." >&2
  exit 1
fi

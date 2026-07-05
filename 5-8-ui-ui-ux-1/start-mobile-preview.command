#!/bin/zsh
set -u

cd "$(dirname "$0")"

PORT=8080
if lsof -nP -iTCP:${PORT} -sTCP:LISTEN >/dev/null 2>&1; then
  PORT=3000
fi
if lsof -nP -iTCP:${PORT} -sTCP:LISTEN >/dev/null 2>&1; then
  PORT=4175
fi

IFACE="$(route get default 2>/dev/null | awk '/interface:/{print $2; exit}')"
IP=""
if [ -n "${IFACE}" ]; then
  IP="$(ipconfig getifaddr "${IFACE}" 2>/dev/null || true)"
fi
if [ -z "${IP}" ]; then
  IP="$(ipconfig getifaddr en0 2>/dev/null || true)"
fi
if [ -z "${IP}" ]; then
  IP="$(ipconfig getifaddr en1 2>/dev/null || true)"
fi

HOST="$(hostname)"
LOCAL_URL="http://127.0.0.1:${PORT}/outputs/index.html"

clear
echo "むしぽけ すまほ ぷれびゅー"
echo
echo "この まどは とじないでください。"
echo
echo "Macでみる:"
echo "${LOCAL_URL}"
echo
if [ -n "${IP}" ]; then
  echo "すまほでみる:"
  echo "http://${IP}:${PORT}/outputs/index.html"
  echo
fi
echo "うえで ひらけないとき:"
echo "http://${HOST}.local:${PORT}/outputs/index.html"
echo
echo "スマホとMacは おなじWi-Fi にしてください。"
echo

open "${LOCAL_URL}" >/dev/null 2>&1 || true
python3 -m http.server "${PORT}" --bind 0.0.0.0


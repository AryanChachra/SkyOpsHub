#!/usr/bin/env sh
# Starts the SkyOpsHub website locally (macOS / Linux). Ctrl+C to stop.
cd "$(dirname "$0")" || exit 1
PORT="${PORT:-5173}"
echo "SkyOpsHub website > http://localhost:$PORT/"
if command -v python3 >/dev/null 2>&1; then exec python3 -m http.server "$PORT" --bind 127.0.0.1; fi
if command -v npx >/dev/null 2>&1; then exec npx --yes serve -l "$PORT" .; fi
echo "Install Python 3 or Node.js, then run this again." >&2
exit 1

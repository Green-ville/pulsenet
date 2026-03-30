#!/usr/bin/env bash
# PulseNet — start backend + frontend together
set -e

ROOT="$(cd "$(dirname "$0")" && pwd)"

# ── Check .env ─────────────────────────────────────────────────────────────────
if [ ! -f "$ROOT/backend/.env" ]; then
  echo "⚠️  backend/.env not found."
  echo "   Run: cp backend/.env.example backend/.env"
  echo "   Then add your ANTHROPIC_API_KEY."
  exit 1
fi

# ── Backend ────────────────────────────────────────────────────────────────────
echo "🐍  Starting Flask backend on http://localhost:5000"
cd "$ROOT/backend"

if [ ! -d "venv" ]; then
  echo "   Creating virtual environment…"
  python3 -m venv venv
fi

source venv/bin/activate
pip install -q -r requirements.txt
python app.py &
BACKEND_PID=$!

# ── Frontend ───────────────────────────────────────────────────────────────────
echo "⚛️   Starting React frontend on http://localhost:3000"
cd "$ROOT/frontend"

if [ ! -d "node_modules" ]; then
  echo "   Installing npm packages…"
  npm install
fi

npm run dev &
FRONTEND_PID=$!

# ── Cleanup on exit ────────────────────────────────────────────────────────────
trap "echo ''; echo 'Stopping…'; kill $BACKEND_PID $FRONTEND_PID 2>/dev/null; exit 0" SIGINT SIGTERM

echo ""
echo "✅  PulseNet running at http://localhost:3000"
echo "    Press Ctrl+C to stop both servers."
echo ""

wait

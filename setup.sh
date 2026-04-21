#!/usr/bin/env bash
set -euo pipefail

# Zero-click dev environment launcher
# Auto-detects stack, installs deps, and starts dev server

echo "🚀 Booting zero-click dev environment..."

OS=$(uname -s)
echo "OS: $OS"

mkdir -p src scripts logs tmp

# Load env if exists
if [ -f .env ]; then
  export $(grep -v '^#' .env | xargs) || true
fi

# Node setup
if [ -f package.json ]; then
  echo "📦 Node project detected"
  if command -v npm >/dev/null 2>&1; then
    npm install
    if npm run | grep -q "dev"; then
      echo "⚡ Starting Node dev server..."
      npm run dev &
    elif npm start >/dev/null 2>&1; then
      echo "⚡ Starting Node app..."
      npm start &
    fi
  fi
fi

# Python setup
if [ -f requirements.txt ] || [ -f pyproject.toml ]; then
  echo "🐍 Python project detected"
  if command -v python3 >/dev/null 2>&1; then
    [ ! -d .venv ] && python3 -m venv .venv
    source .venv/bin/activate
    [ -f requirements.txt ] && pip install -r requirements.txt
    [ -f pyproject.toml ] && pip install . || true
    [ -f main.py ] && python main.py &
  fi
fi

# Docker fallback
if [ -f docker-compose.yml ]; then
  echo "🐳 Docker Compose detected"
  docker compose up -d || true
fi

wait

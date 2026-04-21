#!/usr/bin/env bash
set -euo pipefail

# 🌍 One-command self-booting dev habitat installer
# Usage:
#   curl -fsSL <RAW_URL_TO_THIS_FILE> | bash

REPO_URL="${REPO_URL:-https://github.com/cashpilotthrive-hue/ideal-spork.git}"
PROJECT_DIR="${PROJECT_DIR:-ideal-spork}"

clear || true

echo "🧬 Initializing Dev Habitat..."

# Check dependencies
command -v git >/dev/null 2>&1 || { echo "❌ git is required"; exit 1; }
command -v docker >/dev/null 2>&1 || { echo "❌ docker is required"; exit 1; }
command -v docker compose >/dev/null 2>&1 || { echo "❌ docker compose plugin is required"; exit 1; }

# Clone repo if not exists
if [ ! -d "$PROJECT_DIR" ]; then
  echo "📦 Cloning repository..."
  git clone "$REPO_URL" "$PROJECT_DIR"
fi

cd "$PROJECT_DIR"

echo "🐳 Booting habitat via Docker Compose..."
docker compose up -d --build

echo ""
echo "✨ Dev Habitat Online"
echo "----------------------------------"
echo "📍 App:    http://localhost:3000"
echo "📍 API:    http://localhost:8000"
echo "📍 DB:     localhost:5432"
echo "📍 Redis:  localhost:6379"
echo "----------------------------------"
echo "🧠 Environment is now self-running"
echo ""
echo "To stop: docker compose down"

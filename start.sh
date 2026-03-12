#!/bin/bash

# SupoClip - Start Script (Railway compatible)

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo "============================================"
echo "  SupoClip - AI Video Clipping Tool"
echo "============================================"
echo ""

# Load local .env if it exists (Railway provides env vars automatically)
if [ -f ".env" ]; then
  export $(grep -v '^#' .env | xargs)
fi

# Check required API keys
if [ -z "$ASSEMBLY_AI_API_KEY" ]; then
  echo -e "${YELLOW}Warning: ASSEMBLY_AI_API_KEY is not set.${NC}"
  echo "Video transcription will not work without it."
  echo ""
fi

if [ -z "$OPENAI_API_KEY" ] && [ -z "$GOOGLE_API_KEY" ] && [ -z "$ANTHROPIC_API_KEY" ]; then
  if [[ "${LLM:-}" == ollama:* ]]; then
    :
  else
    echo -e "${YELLOW}Warning: No AI provider API key configured.${NC}"
    echo "Set one of: OPENAI_API_KEY, GOOGLE_API_KEY, ANTHROPIC_API_KEY, or LLM=ollama:<model>"
    echo ""
  fi
fi

echo "Installing backend dependencies..."

python -m pip install --upgrade pip
python -m pip install -r backend/requirements.txt

echo "Starting SupoClip server..."

PORT=${PORT:-8080}

cd backend
python -m uvicorn main:app --host 0.0.0.0 --port $PORT

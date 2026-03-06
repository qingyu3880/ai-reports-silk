#!/bin/bash
# Daily AI Brief - Main Script
# Usage: ./run.sh [date_override]

set -e

WORKSPACE="/root/.openclaw/workspace"
REPORTS_DIR="$WORKSPACE/reports"
DATE=${1:-$(date +%Y-%m-%d)}

echo "📊 Generating AI Daily Brief for $DATE..."

# Ensure directories exist
mkdir -p "$REPORTS_DIR"

# The actual work is done by the agent using kimi_search
# This script is a placeholder for future automation
echo "Report will be generated at: $REPORTS_DIR/ai-daily-$DATE.md"
echo "Run this via OpenClaw agent for full functionality."

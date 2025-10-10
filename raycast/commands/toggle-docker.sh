#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Toggle Docker
# @raycast.mode fullOutput

# Optional parameters:
# @raycast.icon 🐳
# @raycast.packageName Developer Utility
# @raycast.needsConfirmation false

# Documentation:
# @raycast.author Hardik Soni
# @raycast.authorURL https://raycast.com/hs094
# @raycast.description Toggle Docker via Colima. Starts Colima with custom resources if Docker is not running; stops Colima if Docker is running.

# ----------------------------
# Docker Toggle Logic
# ----------------------------

# Check if Docker CLI is available
if ! command -v docker &> /dev/null; then
  echo "❌ Docker CLI not found. Please install Docker and Colima."
  exit 1
fi

# Function to start Colima
start_colima() {
  echo "🚀 Starting Docker via Colima..."
  colima start --cpu 2 --memory 4 --disk 20 --vm-type=vz --arch=aarch64
  if [ $? -eq 0 ]; then
    echo "✅ Colima started successfully!"
  else
    echo "❌ Failed to start Colima."
  fi
}

# Function to stop Colima
stop_colima() {
  echo "🛑 Stopping Docker (Colima)..."
  colima stop
  if [ $? -eq 0 ]; then
    echo "✅ Colima stopped successfully!"
  else
    echo "❌ Failed to stop Colima."
  fi
}

# Check if Docker daemon is running
if docker info &> /dev/null; then
  stop_colima
else
  start_colima
fi

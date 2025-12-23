#!/bin/bash

# Docker Setup with Lima on macOS
# This script automates the installation and configuration of Docker using Lima
# on macOS. Lima is a lightweight virtual machine manager that allows you to
# run Linux virtual machines on macOS, making it an excellent choice for
# running Docker containers.
#
# Prerequisites:
# - A macOS machine
# - Homebrew installed on your macOS machine
# - Basic knowledge of terminal commands

set -euo pipefail  # Exit on error, undefined vars, pipe failures

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running on macOS
if [[ "$(uname)" != "Darwin" ]]; then
    log_error "This script is designed for macOS only."
    exit 1
fi

# Check if Homebrew is installed
if ! command -v brew &> /dev/null; then
    log_error "Homebrew is not installed. Please install Homebrew first:"
    echo "  /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
    exit 1
fi

log_info "Starting Docker setup with Lima..."

# Step 1: Install Lima
log_info "Step 1: Installing Lima..."
if command -v limactl &> /dev/null; then
    log_warn "Lima is already installed. Skipping installation."
else
    brew install lima
    log_info "Lima installed successfully."
fi

# Step 2: Install Docker CLI
log_info "Step 2: Installing Docker CLI..."
if command -v docker &> /dev/null; then
    log_warn "Docker CLI is already installed. Skipping installation."
else
    brew install docker
    log_info "Docker CLI installed successfully."
fi

# Step 3: Create a Lima Instance
log_info "Step 3: Creating Lima instance with Docker support..."
if limactl list 2>/dev/null | grep -q "docker.*Running" || limactl list 2>/dev/null | grep -q "docker.*Stopped"; then
    log_warn "Lima Docker instance already exists."
    # Check if it's running, if not start it
    if limactl list 2>/dev/null | grep -q "docker.*Stopped"; then
        log_info "Starting existing Lima Docker instance..."
        limactl start docker || true
    fi
else
    log_info "Creating new Lima instance with Docker template..."
    limactl start template://docker
    log_info "Lima Docker instance created successfully."
fi

# Step 4: Configure Docker CLI to Use Lima
log_info "Step 4: Configuring Docker CLI to use Lima..."

# Get the current user's home directory
USER_HOME="${HOME}"
DOCKER_SOCK_PATH="${USER_HOME}/.lima/docker/sock/docker.sock"

# Check if Docker context already exists
if docker context ls | grep -q "lima-docker"; then
    log_warn "Docker context 'lima-docker' already exists."
    # Check if it's already in use
    if docker context ls | grep -q "lima-docker.*\*"; then
        log_info "Docker context 'lima-docker' is already in use."
    else
        log_info "Switching to 'lima-docker' context..."
        docker context use lima-docker
    fi
else
    log_info "Creating Docker context 'lima-docker'..."
    docker context create lima-docker --docker "host=unix://${DOCKER_SOCK_PATH}"
    log_info "Switching to 'lima-docker' context..."
    docker context use lima-docker
    log_info "Docker context configured successfully."
fi

# Step 5: Test Docker Installation
log_info "Step 5: Testing Docker installation with hello-world..."
if docker run --rm hello-world; then
    log_info "Docker is working correctly! Setup completed successfully."
else
    log_error "Docker test failed. Please check the Lima instance status:"
    echo "  limactl list"
    echo "  limactl shell docker"
    exit 1
fi

log_info "Setup complete! Docker is now configured to use Lima on macOS."

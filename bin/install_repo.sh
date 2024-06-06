#!/bin/bash
# Install script. Copy into /usr/local/bin before setting up server.
set -e

# Debug output
echo "Cloning repository..."
echo "Current directory: $(pwd)"

# Set the GitHub repository URL, target directory, and Docker Compose file
REPO_URL="https://github.com/brown-a2/ox-build.git"
TARGET_DIR="/usr/local/bin/ox-build"
#DOCKER_COMPOSE_FILE="docker-compose-prod.yml"

# Clone the repository
git clone "$REPO_URL" "$TARGET_DIR"

# Navigate to the target directory
cd "$TARGET_DIR"
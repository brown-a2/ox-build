#!/bin/bash

# Set the GitHub repository URL, target directory, and Docker Compose file
REPO_URL="https://github.com/brown-a2/ox-build.git"
TARGET_DIR="/"
DOCKER_COMPOSE_FILE="docker-compose-prod.yml"

# Clone the repository
git clone "$REPO_URL" "$TARGET_DIR"

# Navigate to the target directory
cd "$TARGET_DIR"

# Install the repository (replace this with your installation command)
# For example, if it's a Python project, you might run:
# pip install .
# Or if it's a Node.js project, you might run:
# npm install
# Adjust this line based on the requirements of your repository.
# If no installation is needed, you can remove this line.
# Example:
# npm install

# Run Docker Compose in the directory
#docker-compose -f "$DOCKER_COMPOSE_FILE" up -d
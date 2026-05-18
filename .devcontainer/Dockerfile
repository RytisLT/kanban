FROM node:22-slim

# Install dependencies required for native modules (node-pty, etc.) and development
RUN apt-get update && apt-get install -y \
    make \
    g++ \
    python3 \
    libsecret-1-dev \
    git \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /workspace

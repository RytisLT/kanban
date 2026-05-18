FROM node:22-slim

# Install dependencies required for native modules (node-pty, etc.)
RUN apt-get update && apt-get install -y \
    make \
    g++ \
    python3 \
    libsecret-1-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy lock files + package.json first for better cache hits
COPY package.json package-lock.json ./
COPY web-ui/package.json web-ui/package-lock.json ./web-ui/

# Install dependencies
RUN npm ci

# Install web-ui dependencies
RUN npm ci --prefix web-ui

# Copy source files
COPY src ./src
COPY web-ui ./web-ui
COPY packages ./packages
COPY scripts ./scripts
COPY tsconfig*.json ./
COPY vitest.config.ts ./
COPY grit ./grit
COPY man ./man

# Build the project
RUN npm run build

# Install globally (mirrors `npm install -g kanban`)
# Creates /usr/local/bin/kanban -> ../lib/node_modules/kanban/dist/cli.js
RUN npm install -g .

# Set working directory
WORKDIR /root

EXPOSE 3484

CMD ["sh", "-c", "kanban --host 0.0.0.0 --port 3484 --no-open"]

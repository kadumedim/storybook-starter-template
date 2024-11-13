# Build stage
FROM node:20-alpine AS builder

WORKDIR /app

# Copy package files
COPY package.json package-lock.json ./

# Install dependencies
RUN npm ci

# Copy source files
COPY . .

# Build Storybook
RUN npm run build-storybook

# Serve stage
FROM caddy:2-alpine

# Copy the built Storybook files from builder stage
COPY --from=builder /app/storybook-static/ /app/storybook-static/

# Copy Caddyfile
COPY Caddyfile /etc/caddy/Caddyfile
# Builder stage
FROM node:20 AS builder

WORKDIR /app

COPY app/ .

# Runtime stage
FROM node:20-alpine

LABEL org.opencontainers.image.title="demo-app"
LABEL org.opencontainers.image.description="Day 5 Docker assignment"
LABEL org.opencontainers.image.version="1.0.0"

WORKDIR /app

COPY --from=builder /app .

EXPOSE 3000

HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
  CMD wget -qO- http://localhost:3000 || exit 1

USER node

CMD ["node", "server.js"]


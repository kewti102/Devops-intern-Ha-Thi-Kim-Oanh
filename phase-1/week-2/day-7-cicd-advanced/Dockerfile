FROM node:20-alpine

WORKDIR /app

COPY package*.json ./


RUN npm install -g npm@latest
RUN npm ci
RUN apk update && apk upgrade --no-cache


COPY . .

EXPOSE 3000

USER node
CMD ["node", "app/server.js"]

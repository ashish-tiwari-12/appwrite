FROM node:20 AS builder

WORKDIR /app

# install pnpm
RUN npm install -g pnpm

# install bun
RUN curl -fsSL https://bun.sh/install | bash
ENV PATH="/root/.bun/bin:$PATH"

COPY package.json pnpm-lock.yaml ./
RUN pnpm install

COPY . .
RUN pnpm run build



# Production stage
FROM node:20-slim

WORKDIR /app

COPY --from=builder /app/build ./build
COPY --from=builder /app/server ./server
COPY --from=builder /app/node_modules ./node_modules

ENV HOST=0.0.0.0
ENV PORT=3000

EXPOSE 3000

CMD ["node", "server/main.js"]

ARG IMAGE_PREFIX
ARG IMAGE_EXT_PREFIX

FROM ${IMAGE_EXT_PREFIX}node-alpine AS builder

ARG APP_ENV

RUN if [ "$APP_ENV" = "dev" ]; then \
    npm config set registry https://registry.npmmirror.com; \
    fi

RUN npm install -g pnpm

WORKDIR /app

COPY package.json pnpm-lock.yaml ./

RUN --mount=type=cache,id=pnpm,target=/root/.local/share/pnpm/store \
    pnpm install --frozen-lockfile; \
    pnpm ls

COPY . .

RUN pnpm run docs:build

FROM ${IMAGE_PREFIX}nginx:latest

COPY --from=builder /app/.vitepress/dist /app
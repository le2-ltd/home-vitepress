ARG IMAGE_MIRROR

FROM ${IMAGE_MIRROR}node:alpine AS builder

ARG APK_REPOSITORY
ARG NPM_REGISTRY

RUN if [ -n "$APK_REPOSITORY" ]; then \
        sed -i \
            -e "s|https://dl-cdn.alpinelinux.org/alpine|$APK_REPOSITORY|g" \
            -e "s|http://dl-cdn.alpinelinux.org/alpine|$APK_REPOSITORY|g" \
            /etc/apk/repositories; \
    fi

RUN apk add --no-cache git ca-certificates;

RUN if [ -n "$NPM_REGISTRY" ]; then \
        npm config set registry "$NPM_REGISTRY"; \
    fi

RUN npm install -g pnpm

WORKDIR /app

COPY package.json pnpm-lock.yaml ./

RUN --mount=type=cache,id=pnpm,target=/root/.local/share/pnpm/store \
    pnpm install --frozen-lockfile; \
    pnpm ls

COPY . .

RUN pnpm run docs:build

FROM ${IMAGE_MIRROR}nginx:latest

COPY --from=builder /app/.vitepress/dist /usr/share/nginx/html

ARG IMAGE_PREFIX

FROM ${IMAGE_PREFIX}node:alpine AS builder

ARG APP_ENV

RUN if [ "$APP_ENV" = "development" ]; then \
        sed -i \
            -e "s|https://dl-cdn.alpinelinux.org/alpine|http://mirrors.aliyun.com/alpine|g" \
            -e "s|http://dl-cdn.alpinelinux.org/alpine|http://mirrors.aliyun.com/alpine|g" \
            /etc/apk/repositories; \
    fi

RUN apk add --no-cache git ca-certificates;

RUN if [ "$APP_ENV" = "development" ]; then \
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

COPY --from=builder /app/.vitepress/dist /usr/share/nginx/html

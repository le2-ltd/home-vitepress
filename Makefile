-include .env
-include .env.$(APP_ENV)

run-dev:
	npm config set registry $(NPM_REGISTRY)
	pnpm update
	pnpm ls
	pnpm run docs:dev

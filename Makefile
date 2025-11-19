
run-dev:
	npm config set registry https://registry.npmmirror.com
	pnpm update
	pnpm ls
	pnpm run docs:dev

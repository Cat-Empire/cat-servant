GOCMD=go
GOTEST=$(GOCMD) test
GOVET=$(GOCMD) vet
BINARY_NAME=catservant
VERSION?=0.0.0
SERVICE_PORT?=3000
DOCKER_REGISTRY?= #if set it should finished by /
EXPORT_RESULT?=false # for CI please set EXPORT_RESULT to true

GREEN  := $(shell tput -Txterm setaf 2)
YELLOW := $(shell tput -Txterm setaf 3)
WHITE  := $(shell tput -Txterm setaf 7)
CYAN   := $(shell tput -Txterm setaf 6)
RESET  := $(shell tput -Txterm sgr0)

## Run:
run: build ## Run CatBot without building
	./out/bin/$(BINARY_NAME)
## Build:
build: ## Build CatBot (the output binary in out/bin/)
	mkdir -p out/bin
	cp config.json out/bin
	GO111MODULE=on $(GOCMD) build -o out/bin/$(BINARY_NAME) .

clean: ## Remove build related file
	rm -fr ./bin
	rm -fr ./out

docker-build: ## Use the Dockerfile to build container
	docker build -t $(BINARY_NAME)-image .
	docker run -it --rm --name $(BINARY_NAME)-bot $(BINARY_NAME)-image
## Help:
help: ## Show this help
	@echo -e '😺CatServent\n'
	@echo 'Usage:'
	@echo '  ${YELLOW}make${RESET} ${GREEN}<target>${RESET}'
	@echo ''
	@echo 'Targets:'
	@awk 'BEGIN {FS = ":.*?## "} { \
		if (/^[a-zA-Z_-]+:.*?##.*$$/) {printf "    ${YELLOW}%-20s${GREEN}%s${RESET}\n", $$1, $$2} \
		else if (/^## .*$$/) {printf "  ${CYAN}%s${RESET}\n", substr($$1,4)} \
		}' $(MAKEFILE_LIST)

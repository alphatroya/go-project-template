GOIMPORTS := go run golang.org/x/tools/cmd/goimports@v0.1.11
GOFUMPT := go run mvdan.cc/gofumpt@v0.3.1
GOLANGCI := go run github.com/golangci/golangci-lint/cmd/golangci-lint@v1.46.2
SWAGGER_DOC := go run github.com/swaggo/swag/cmd/swag@v1.8.1
WATCHER := go run github.com/cosmtrek/air@v1.40.2

## build: Build an application
.PHONY: build
build: fmt docs
	go build -v -o main

## install: Install application
.PHONY: install
install:
	go install -v

## run: Run application
.PHONY: run
run: fmt docs
	go run .

## test: Launch unit tests
.PHONY: test
test:
	go test ./...

## coverage: Launch unit tests
.PHONY: coverage
coverage:
	@go test -v -coverpkg=./... -coverprofile=profile.cov ./... > /dev/null
	@go tool cover -func profile.cov | tail -n 1
	@rm -fr profile.cov

## clean: Cleanup build artefacts
.PHONY:
clean:
	go clean

## docs: Regenerate swagger docs
.PHONY: docs
docs: generate
	$(SWAGGER_DOC) init

## generate: Regenerate all required files
generate:
	go generate

## tidy: Cleanup go.sum and go.mod files
.PHONY: tidy
tidy:
	go mod tidy

## lint: Launch project linters
.PHONY: lint
lint:
	$(GOLANGCI) run

## fmt: Reformat source code
.PHONY: fmt
fmt:
	$(SWAGGER_DOC) fmt
	$(GOIMPORTS) -w -l .
	$(GOFUMPT) -w -l .

## watch: run application and launch files observing for recompile package for changes
.PHONY: watch
watch:
	$(WATCHER)

## help: Prints help message
.PHONY: help
help:
	@echo "Usage: \n"
	@sed -n 's/^##//p' ${MAKEFILE_LIST} | column -t -s ':' |  sed -e 's/^/ /' | sort

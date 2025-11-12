# Variables
BINARY_NAME=crawler
MAIN_PATH=./cmd/crawler
BUILD_DIR=bin

# Default target
.PHONY: help
help:
	@echo "Available commands:"
	@echo "  setup    - Install golangci-lint and setup pre-commit hooks"
	@echo "  build    - Build the binary"
	@echo "  run      - Build and run the application"
	@echo "  test     - Run tests"
	@echo "  test/coverage - Run tests with coverage"
	@echo "  lint     - Run linter"
	@echo "  lint/fix - Run linter with auto-fix"
	@echo "  clean    - Remove build artifacts"

# Setup development environment
.PHONY: setup
setup:
	@echo "Setting up development environment..."
	@echo "Installing golangci-lint..."
	@curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b $(shell go env GOPATH)/bin
	@echo "Installing pre-commit hook..."
	@mkdir -p .git/hooks
	@echo '#!/bin/sh' > .git/hooks/pre-commit
	@echo 'echo "Running pre-commit checks..."' >> .git/hooks/pre-commit
	@echo '' >> .git/hooks/pre-commit
	@echo 'echo "Building project..."' >> .git/hooks/pre-commit
	@echo 'make build || exit 1' >> .git/hooks/pre-commit
	@echo '' >> .git/hooks/pre-commit
	@echo 'echo "Running tests..."' >> .git/hooks/pre-commit
	@echo 'make test || exit 1' >> .git/hooks/pre-commit
	@echo '' >> .git/hooks/pre-commit
	@echo 'echo "Running linter with auto-fix..."' >> .git/hooks/pre-commit
	@echo 'make lint/fix || exit 1' >> .git/hooks/pre-commit
	@echo '' >> .git/hooks/pre-commit
	@echo 'echo "All pre-commit checks passed!"' >> .git/hooks/pre-commit
	@chmod +x .git/hooks/pre-commit
	@echo "Setup complete! Pre-commit hook installed."

# Build the binary
.PHONY: build
build:
	@mkdir -p $(BUILD_DIR)
	go build -o $(BUILD_DIR)/$(BINARY_NAME) $(MAIN_PATH)

# Run the application
.PHONY: run
run: build
	./$(BUILD_DIR)/$(BINARY_NAME)

# Run tests
.PHONY: test
test:
	go test -v -race -buildvcs ./...

# Run tests with coverage
.PHONY: test/coverage
test/coverage:
	go test -v -race -buildvcs -coverprofile=.coverage.out ./...
	go tool cover -html=.coverage.out

.PHONY: lint
lint:
	golangci-lint run

.PHONY: lint/fix
lint/fix:
	golangci-lint run --fix

# Clean build artifacts
.PHONY: clean
clean:
	rm -rf $(BUILD_DIR)

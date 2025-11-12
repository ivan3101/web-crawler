# Variables
BINARY_NAME=crawler
MAIN_PATH=./cmd/crawler
BUILD_DIR=bin

# Default target
.PHONY: help
help:
	@echo "Available commands:"
	@echo "  build    - Build the binary"
	@echo "  run      - Build and run the application"
	@echo "  test     - Run tests"
	@echo "  clean    - Remove build artifacts"

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
	go test -v ./...

# Clean build artifacts
.PHONY: clean
clean:
	rm -rf $(BUILD_DIR)

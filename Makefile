# SwiftUIEnhancement Makefile
# Build targets for iOS and macOS development

.PHONY: help build-ios build-macos build-all clean test lint format

# Default target
help:
	@echo "SwiftUIEnhancement Build System"
	@echo ""
	@echo "Available targets:"
	@echo "  build-ios      - Build for iOS Simulator"
	@echo "  build-macos    - Build for macOS"
	@echo "  build-all      - Build for both iOS and macOS"
	@echo "  test-ios       - Run tests on iOS Simulator"
	@echo "  test-macos     - Run tests on macOS"
	@echo "  test-all       - Run tests on both platforms"
	@echo "  clean          - Clean build artifacts"
	@echo "  lint           - Run SwiftLint (if available)"
	@echo "  format         - Format code with swift-format (if available)"
	@echo "  help           - Show this help message"

# Build targets
build-ios:
	@echo "Building for iOS Simulator..."
	xcodebuild -scheme SwiftUIEnhancement \
		-destination 'platform=iOS Simulator,name=iPhone 16,OS=latest' \
		build

build-macos:
	@echo "Building for macOS..."
	xcodebuild -scheme SwiftUIEnhancement \
		-destination 'platform=macOS' \
		build

build-all: build-macos build-ios
	@echo "✅ Successfully built for both macOS and iOS"

# Test targets
test-ios:
	@echo "Running tests on iOS Simulator..."
	xcodebuild -scheme SwiftUIEnhancement \
		-destination 'platform=iOS Simulator,name=iPhone 16,OS=latest' \
		test

test-macos:
	@echo "Running tests on macOS..."
	xcodebuild -scheme SwiftUIEnhancement \
		-destination 'platform=macOS' \
		test

test-all: test-macos test-ios
	@echo "✅ Successfully ran tests on both platforms"

# Clean target
clean:
	@echo "Cleaning build artifacts..."
	xcodebuild clean
	rm -rf .build
	rm -rf .swiftpm

# Linting and formatting (optional tools)
lint:
	@if command -v swiftlint >/dev/null 2>&1; then \
		echo "Running SwiftLint..."; \
		swiftlint; \
	else \
		echo "⚠️  SwiftLint not found. Install with: brew install swiftlint"; \
	fi

format:
	@if command -v swift-format >/dev/null 2>&1; then \
		echo "Formatting Swift code..."; \
		find Sources -name "*.swift" -exec swift-format -i {} \;; \
		find Tests -name "*.swift" -exec swift-format -i {} \; 2>/dev/null || true; \
	else \
		echo "⚠️  swift-format not found. Install with: brew install swift-format"; \
	fi

# Development workflow targets
dev-setup: 
	@echo "Setting up development environment..."
	@if ! command -v swiftlint >/dev/null 2>&1; then \
		echo "Installing SwiftLint..."; \
		brew install swiftlint; \
	fi
	@if ! command -v swift-format >/dev/null 2>&1; then \
		echo "Installing swift-format..."; \
		brew install swift-format; \
	fi
	@echo "✅ Development environment ready"

# Quick validation before committing
validate: lint build-all test-all
	@echo "✅ All validation checks passed"

# Package info
info:
	@echo "Package Information:"
	@echo "===================="
	@swift package describe --type json | jq -r '.name, .platforms[]'
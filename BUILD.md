# UsefulThingsSwiftUI Build Guide

This document describes how to build and develop the UsefulThingsSwiftUI package for both macOS and iOS platforms.

## Prerequisites

- Xcode 16.0 or later
- macOS 13.0 or later
- iOS 14.0 or later (for iOS builds)

## Quick Start

The package includes a Makefile for easy building and development workflows.

### Build Commands

```bash
# Show all available commands
make help

# Build for macOS only
make build-macos

# Build for iOS Simulator only  
make build-ios

# Build for both platforms
make build-all
```

### Testing Commands

```bash
# Run tests on macOS
make test-macos

# Run tests on iOS Simulator
make test-ios

# Run tests on both platforms
make test-all
```

### Development Commands

```bash
# Clean build artifacts
make clean

# Format code (requires swift-format)
make format

# Run linting (requires SwiftLint)
make lint

# Set up development environment (installs tools)
make dev-setup

# Run full validation (lint + build + test)
make validate
```

## Platform-Specific Features

### macOS-Only Features
The following components are only available on macOS:
- `OpenInWindow` - Window management utilities
- `FloatingPanel` - Floating panel implementation
- `DoubleClick` - Advanced click handling
- `PopoverView` - NSPopover integration
- `PatientTextEditor` - NSTextView-based editor

### iOS-Compatible Features
Most SwiftUI extensions work on both platforms:
- `VisualEffectView` - Platform-specific blur effects
- `PopupButton` - Menu button with platform-appropriate implementation
- `Color+` extensions - Color manipulation utilities
- `SplashView` - Animated effects
- All basic SwiftUI modifiers and utilities

### Cross-Platform Implementation
The package uses compiler guards (`#if os(macOS)` / `#if os(iOS)`) to provide platform-specific implementations while maintaining a consistent API.

## Manual Building

If you prefer not to use the Makefile:

### macOS
```bash
xcodebuild -scheme UsefulThingsSwiftUI -destination 'platform=macOS' build
```

### iOS Simulator
```bash
xcodebuild -scheme UsefulThingsSwiftUI -destination 'platform=iOS Simulator,name=iPhone 16,OS=latest' build
```

## Integration

Add to your `Package.swift`:

```swift
dependencies: [
    .package(url: "path/to/UsefulThingsSwiftUI", from: "1.0.0")
],
targets: [
    .target(
        name: "YourTarget",
        dependencies: ["UsefulThingsSwiftUI"]
    )
]
```

## Development Tools

### Optional Tools Installation
```bash
# Install SwiftLint for code quality
brew install swiftlint

# Install swift-format for code formatting  
brew install swift-format

# Or install both automatically
make dev-setup
```

## Troubleshooting

### Common Issues

1. **iOS Build Fails**: Ensure you're using Xcode 16.0+ and targeting iOS 14.0+
2. **macOS Build Fails**: Check that macOS deployment target is 13.0+
3. **Missing Tools**: Run `make dev-setup` to install development dependencies

### Platform Availability
Some features require specific iOS/macOS versions due to SwiftUI API availability:
- iOS Color extensions require iOS 15.0+
- Some advanced features require iOS 17.0+
- macOS features generally require macOS 13.0+

## Contributing

When making changes:
1. Run `make validate` before committing
2. Ensure both platform builds succeed
3. Test on both macOS and iOS when possible
4. Use platform guards for platform-specific code
# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build Commands

Use the Makefile for all development tasks:

```bash
# Build for both platforms
make build-all

# Test on both platforms  
make test-all

# Run linting (requires SwiftLint)
make lint

# Format code (requires swift-format)
make format

# Full validation before committing
make validate

# Set up development environment
make dev-setup
```

For platform-specific builds:
```bash
make build-macos    # macOS only
make build-ios      # iOS Simulator only
make test-macos     # Test on macOS
make test-ios       # Test on iOS Simulator
```

## Architecture

This is a SwiftUI enhancement library that provides cross-platform UI components and utilities for iOS (14+) and macOS (13+). The architecture uses compiler guards to provide platform-specific implementations while maintaining consistent APIs.

### Platform Strategy
- **Cross-platform components**: Use `#if os(macOS)` / `#if os(iOS)` guards to provide platform-specific implementations
- **Shared APIs**: Components like `PopupButton` and `VisualEffectView` have identical public interfaces but different underlying implementations
- **Platform-exclusive features**: Some components (like `OpenInWindow`, `FloatingPanel`) are macOS-only

### Key Components
- **PopupButton**: NSPopUpButton wrapper (macOS) / UIButton with UIMenu (iOS)
- **VisualEffectView**: NSVisualEffectView wrapper (macOS) / UIVisualEffectView wrapper (iOS)
- **Platform-specific utilities**: Window management (macOS), advanced text editing, popover views
- **Cross-platform modifiers**: Color extensions, animations, layout utilities

### Code Organization
- All source files are in `Sources/SwiftUIEnhancement/`
- Each component is typically self-contained in a single file
- Platform guards are used at the top level of files for entire implementations
- Tests are in `Tests/SwiftUIEnhancementTests/`

## Development Guidelines

### Platform Compatibility
- Always test on both macOS and iOS when adding cross-platform features
- Use appropriate minimum deployment targets (iOS 14+, macOS 13+)
- Some advanced features require newer OS versions - document these requirements

### Code Style
- Use SwiftLint for code quality (`make lint`)
- Use swift-format for formatting (`make format`)
- Follow existing patterns for platform guards and API consistency

### Testing
- Run `make validate` before committing to ensure all platforms build and test successfully
- Both macOS and iOS test suites must pass

### Adding New Components
- For cross-platform components: create platform-specific implementations with identical public APIs
- For platform-specific components: use appropriate compiler guards
- Follow existing naming conventions and API patterns
- Update BUILD.md if new platform requirements are introduced
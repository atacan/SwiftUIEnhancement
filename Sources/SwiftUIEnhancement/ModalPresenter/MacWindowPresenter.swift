#if os(macOS)
import AppKit
import SwiftUI

@MainActor
public final class MacWindowPresenter<Content: View>: NSObject, ModalPresenter, NSWindowDelegate {
    public struct Configuration: Sendable {
        public var title: String
        public var rect: CGRect
        public var styleMask: NSWindow.StyleMask
        public var centerOnScreen: Bool
        public var makeKey: Bool

        public init(
            title: String = "Input Required",
            rect: CGRect = CGRect(x: 0, y: 0, width: 520, height: 260),
            styleMask: NSWindow.StyleMask = [.titled, .closable, .miniaturizable, .resizable],
            centerOnScreen: Bool = true,
            makeKey: Bool = true
        ) {
            self.title = title
            self.rect = rect
            self.styleMask = styleMask
            self.centerOnScreen = centerOnScreen
            self.makeKey = makeKey
        }
    }

    public struct Token {
        fileprivate let window: NSWindow
    }

    private var cancelHandlers: [ObjectIdentifier: () -> Void] = [:]
    private var programmaticCloseIDs = Set<ObjectIdentifier>()
    private var closingIDs = Set<ObjectIdentifier>()
    private let configuration: Configuration

    public init(configuration: Configuration = Configuration()) {
        self.configuration = configuration
        super.init()
    }

    public func present(
        _ content: Content,
        onUserCancel: @escaping () -> Void
    ) -> Token {
        let hosting = NSHostingController(rootView: content)

        let initialFrame = resolvedInitialFrame()
        let window = NSWindow(
            contentRect: initialFrame,
            styleMask: configuration.styleMask,
            backing: .buffered,
            defer: false
        )
        window.contentViewController = hosting
        window.title = configuration.title
        window.isReleasedWhenClosed = false
        window.delegate = self

        let id = ObjectIdentifier(window)
        cancelHandlers[id] = onUserCancel
        programmaticCloseIDs.remove(id)

        NSApp.activate(ignoringOtherApps: true)
        if configuration.makeKey {
            window.makeKeyAndOrderFront(nil)
        } else {
            window.orderFront(nil)
        }
        if configuration.centerOnScreen {
            window.contentView?.layoutSubtreeIfNeeded()
            centerWindow(window)
            Task { @MainActor in
                await Task.yield()
                centerWindow(window)
            }
        }

        return Token(window: window)
    }

    public func dismiss(_ token: Token) {
        let id = ObjectIdentifier(token.window)
        if closingIDs.contains(id) {
            cancelHandlers[id] = nil
            programmaticCloseIDs.remove(id)
            return
        }

        programmaticCloseIDs.insert(id)
        token.window.close()
    }

    public func windowShouldClose(_ sender: NSWindow) -> Bool {
        let id = ObjectIdentifier(sender)
        closingIDs.insert(id)
        defer { closingIDs.remove(id) }

        if programmaticCloseIDs.contains(id) {
            programmaticCloseIDs.remove(id)
            cancelHandlers[id] = nil
            return true
        }

        if let cancel = cancelHandlers[id] {
            cancelHandlers[id] = nil
            cancel()
        }

        return true
    }

    private func resolvedInitialFrame() -> CGRect {
        if configuration.centerOnScreen {
            if let screen = preferredScreen() {
                return centeredFrame(for: configuration.rect, in: screen)
            }
        }
        return configuration.rect
    }

    private func centerWindow(_ window: NSWindow) {
        guard let screen = preferredScreen(for: window) else { return }
        var size = window.frame.size
        if size.width <= 0 || size.height <= 0 {
            size = configuration.rect.size
        }
        let centered = centeredFrame(for: CGRect(origin: .zero, size: size), in: screen)
        window.setFrame(centered, display: true)
    }

    private func preferredScreen(for window: NSWindow? = nil) -> NSScreen? {
        window?.screen
            ?? NSApp.keyWindow?.screen
            ?? NSApp.mainWindow?.screen
            ?? NSScreen.main
            ?? NSScreen.screens.first
    }

    private func centeredFrame(for rect: CGRect, in screen: NSScreen) -> CGRect {
        let visible = screen.visibleFrame
        let size = rect.size
        let origin = CGPoint(
            x: visible.midX - size.width / 2,
            y: visible.midY - size.height / 2
        )
        return CGRect(origin: origin, size: size)
    }
}
#endif

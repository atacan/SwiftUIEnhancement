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

        let window = NSWindow(
            contentRect: configuration.rect,
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
            window.center()
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
}
#endif

#if os(macOS)
import AppKit
import SwiftUI

@MainActor
public final class MacWindowPresenter<Content: View>: NSObject, ModalPresenter, NSWindowDelegate {
    public struct Token {
        fileprivate let window: NSWindow
    }

    private var cancelHandlers: [ObjectIdentifier: () -> Void] = [:]
    private var programmaticCloseIDs = Set<ObjectIdentifier>()
    private var closingIDs = Set<ObjectIdentifier>()

    public override init() {}

    public func present(
        _ content: Content,
        onUserCancel: @escaping () -> Void
    ) -> Token {
        let hosting = NSHostingController(rootView: content)

        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 520, height: 260),
            styleMask: [.titled, .closable, .miniaturizable, .resizable],
            backing: .buffered,
            defer: false
        )
        window.contentViewController = hosting
        window.title = "Input Required"
        window.isReleasedWhenClosed = false
        window.delegate = self
        window.center()

        let id = ObjectIdentifier(window)
        cancelHandlers[id] = onUserCancel
        programmaticCloseIDs.remove(id)

        NSApp.activate(ignoringOtherApps: true)
        window.makeKeyAndOrderFront(nil)

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

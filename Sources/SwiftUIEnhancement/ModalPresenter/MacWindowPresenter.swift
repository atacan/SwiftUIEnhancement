#if os(macOS)
import AppKit
import ObjectiveC
import SwiftUI

@MainActor
public final class MacWindowPresenter: NSObject, ModalPresenter, NSWindowDelegate {
    public struct Token {
        fileprivate let window: NSWindow
        fileprivate let cancel: () -> Void
    }

    public override init() {}

    public func present<Content: View>(
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

        objc_setAssociatedObject(
            window,
            &Self.cancelKey,
            onUserCancel,
            .OBJC_ASSOCIATION_RETAIN_NONATOMIC
        )

        NSApp.activate(ignoringOtherApps: true)
        window.makeKeyAndOrderFront(nil)

        return Token(window: window, cancel: onUserCancel)
    }

    public func dismiss(_ token: Token) {
        objc_setAssociatedObject(token.window, &Self.cancelKey, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        token.window.close()
    }

    public func windowWillClose(_ notification: Notification) {
        guard let window = notification.object as? NSWindow else { return }
        if let cancel = objc_getAssociatedObject(window, &Self.cancelKey) as? (() -> Void) {
            objc_setAssociatedObject(window, &Self.cancelKey, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            cancel()
        }
    }

    private static var cancelKey: UInt8 = 0
}
#endif

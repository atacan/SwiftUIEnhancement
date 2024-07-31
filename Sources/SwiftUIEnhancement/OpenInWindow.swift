import SwiftUI

extension View {
    private func newWindowInternal(with title: String) -> NSWindow {
        let window = NSWindow(
            contentRect: NSRect(x: 20, y: 20, width: 680, height: 600),
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
            backing: .buffered,
            defer: false
        )
        window.center()
        window.isReleasedWhenClosed = false
        window.title = title
        window.titlebarAppearsTransparent = true
        window.isMovableByWindowBackground = true
        window.makeKeyAndOrderFront(nil)
        return window
    }

    @available(
      macOS,
      deprecated: 9999,
      message:
        "Use `openInNewWindow`"
    )
    public func openNewWindow(with title: String = "New Window") {
        newWindowInternal(with: title).contentView = NSHostingView(rootView: self)
    }
    
    @MainActor
    public func openInNewWindow(title: String, rect: CGRect = .init(x: 20, y: 20, width: 680, height: 600)) {
        let window = NSWindow(
            contentRect: rect,
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
            backing: .buffered,
            defer: false
        )
        window.center()
        window.isReleasedWhenClosed = false
        window.title = title
        window.titlebarAppearsTransparent = true
        window.isMovableByWindowBackground = true
        window.makeKeyAndOrderFront(nil)
        window.contentView = NSHostingView(rootView: self)
    }
}

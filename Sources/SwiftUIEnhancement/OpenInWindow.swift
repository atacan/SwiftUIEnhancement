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
    public func openInNewWindow(
        title: String,
        rect: CGRect = .init(x: 20, y: 20, width: 680, height: 700),
        makeKey: Bool = false
    ) {
        let window = NSWindow(
            contentRect: rect,
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
            backing: .buffered,
            defer: false
        )
        window.center()
        let centerFrame = window.frame
        window.isReleasedWhenClosed = false
        window.title = title
        window.titlebarAppearsTransparent = true
        window.isMovableByWindowBackground = true
        window.contentView = NSHostingView(rootView: self)
        if makeKey {
            window.orderFront(nil)
        } else {
            window.makeKeyAndOrderFront(nil)
        }
        window.animator().setFrame(
            .init(x: centerFrame.minX + Double.random(in: -50...50), y: centerFrame.minY + Double.random(in: -50...50), width: centerFrame.width, height: centerFrame.height),
            display: true,
            animate: true
        )
    }
}

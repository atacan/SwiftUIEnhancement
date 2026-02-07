#if os(iOS) || os(macOS)
import SwiftUI
#if os(macOS)
import AppKit
#endif

@MainActor
public final class PopoverPresenter<Content: View>: ObservableObject, ModalPresenter {
    public struct Token: Hashable {
        fileprivate let id: UUID
    }

    struct Item {
        let id: UUID
        let content: Content
        let onCancel: () -> Void
    }

    @Published var item: Item?

    public var attachmentAnchor: PopoverAttachmentAnchor
    public var arrowEdge: Edge
#if os(macOS)
    public var useMouseCursorAnchorOnMacOS: Bool
    weak var anchorView: NSView?
#endif

    private var presentationAttachmentAnchor: PopoverAttachmentAnchor

    private var programmaticDismissID: UUID?

    #if os(macOS)
    public init(
        attachmentAnchor: PopoverAttachmentAnchor = .rect(.bounds),
        arrowEdge: Edge = .top,
        useMouseCursorAnchorOnMacOS: Bool = true
    ) {
        self.attachmentAnchor = attachmentAnchor
        self.arrowEdge = arrowEdge
        self.useMouseCursorAnchorOnMacOS = useMouseCursorAnchorOnMacOS
        self.presentationAttachmentAnchor = attachmentAnchor
    }
    #else
    public init(
        attachmentAnchor: PopoverAttachmentAnchor = .rect(.bounds),
        arrowEdge: Edge = .top
    ) {
        self.attachmentAnchor = attachmentAnchor
        self.arrowEdge = arrowEdge
        self.presentationAttachmentAnchor = attachmentAnchor
    }
    #endif

    public func present(
        _ content: Content,
        onUserCancel: @escaping () -> Void
    ) -> Token {
        if let existing = item {
            existing.onCancel()
        }

        presentationAttachmentAnchor = resolvedAttachmentAnchor()
        let newItem = Item(id: UUID(), content: content, onCancel: onUserCancel)
        programmaticDismissID = nil
        item = newItem
        return Token(id: newItem.id)
    }

    public func dismiss(_ token: Token) {
        programmaticDismissID = token.id
        item = nil
    }

    fileprivate func binding() -> Binding<Bool> {
        Binding(
            get: { self.item != nil },
            set: { newValue in
                guard !newValue, let dismissedItem = self.item else { return }
                self.item = nil
                self.handleUserDismiss(dismissedItem)
            }
        )
    }

    private func handleUserDismiss(_ dismissedItem: Item) {
        let dismissedID = dismissedItem.id

        Task { @MainActor in
            await Task.yield()
            if self.programmaticDismissID == dismissedID {
                self.programmaticDismissID = nil
                return
            }

            dismissedItem.onCancel()
            self.programmaticDismissID = nil
        }
    }

    fileprivate var currentAttachmentAnchor: PopoverAttachmentAnchor {
        presentationAttachmentAnchor
    }

#if os(macOS)
    fileprivate func registerAnchorView(_ view: NSView) {
        if anchorView !== view {
            anchorView = view
        }
    }
#endif

    private func resolvedAttachmentAnchor() -> PopoverAttachmentAnchor {
#if os(macOS)
        guard useMouseCursorAnchorOnMacOS,
            let anchorView,
            let window = anchorView.window
        else {
            return attachmentAnchor
        }

        let screenPoint = NSEvent.mouseLocation
        let windowPoint = window.convertPoint(fromScreen: screenPoint)
        let localPoint = anchorView.convert(windowPoint, from: nil)
        let width = anchorView.bounds.width
        let height = anchorView.bounds.height

        guard width > 0, height > 0 else {
            return attachmentAnchor
        }

        let normalizedX = min(max(localPoint.x / width, 0), 1)
        // UnitPoint y-axis is top-origin, but AppKit view coordinates are bottom-origin.
        let normalizedY = min(max(1 - (localPoint.y / height), 0), 1)
        return .point(UnitPoint(x: normalizedX, y: normalizedY))
#else
        attachmentAnchor
#endif
    }
}

private struct PopoverPresenterModifier<Presented: View>: ViewModifier {
    @ObservedObject var presenter: PopoverPresenter<Presented>

    func body(content: Content) -> some View {
        popoverContainer(content: content).popover(
            isPresented: presenter.binding(),
            attachmentAnchor: presenter.currentAttachmentAnchor,
            arrowEdge: presenter.arrowEdge
        ) {
            if let item = presenter.item {
                item.content
            } else {
                EmptyView()
            }
        }
    }

    @ViewBuilder
    private func popoverContainer(content: Content) -> some View {
#if os(macOS)
        content.background(PopoverAnchorViewReader { anchorView in
            presenter.registerAnchorView(anchorView)
        })
#else
        content
#endif
    }
}

public extension View {
    func popoverPresenter<Presented: View>(_ presenter: PopoverPresenter<Presented>) -> some View {
        modifier(PopoverPresenterModifier(presenter: presenter))
    }
}

#if os(macOS)
private struct PopoverAnchorViewReader: NSViewRepresentable {
    let onUpdate: (NSView) -> Void

    func makeNSView(context: Context) -> NSView {
        let view = NSView(frame: .zero)
        DispatchQueue.main.async {
            onUpdate(view)
        }
        return view
    }

    func updateNSView(_ nsView: NSView, context: Context) {
        DispatchQueue.main.async {
            onUpdate(nsView)
        }
    }
}
#endif
#endif

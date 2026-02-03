#if os(iOS) || os(macOS)
import SwiftUI

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

    private var programmaticDismissID: UUID?

    public init(
        attachmentAnchor: PopoverAttachmentAnchor = .rect(.bounds),
        arrowEdge: Edge = .top
    ) {
        self.attachmentAnchor = attachmentAnchor
        self.arrowEdge = arrowEdge
    }

    public func present(
        _ content: Content,
        onUserCancel: @escaping () -> Void
    ) -> Token {
        if let existing = item {
            existing.onCancel()
        }

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
}

private struct PopoverPresenterModifier<Presented: View>: ViewModifier {
    @ObservedObject var presenter: PopoverPresenter<Presented>

    func body(content: Content) -> some View {
        content.popover(
            isPresented: presenter.binding(),
            attachmentAnchor: presenter.attachmentAnchor,
            arrowEdge: presenter.arrowEdge
        ) {
            if let item = presenter.item {
                item.content
            } else {
                EmptyView()
            }
        }
    }
}

public extension View {
    func popoverPresenter<Presented: View>(_ presenter: PopoverPresenter<Presented>) -> some View {
        modifier(PopoverPresenterModifier(presenter: presenter))
    }
}
#endif

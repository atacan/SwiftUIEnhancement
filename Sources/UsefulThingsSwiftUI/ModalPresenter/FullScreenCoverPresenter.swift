#if os(iOS)
import SwiftUI

@MainActor
public final class FullScreenCoverPresenter<Content: View>: ObservableObject, ModalPresenter {
    public struct Token: Hashable {
        fileprivate let id: UUID
    }

    struct Item: Identifiable {
        let id: UUID
        let content: Content
        let onCancel: () -> Void
    }

    @Published var item: Item?

    private var lastItem: Item?
    private var programmaticDismissID: UUID?

    public init() {}

    public func present(
        _ content: Content,
        onUserCancel: @escaping () -> Void
    ) -> Token {
        if let existing = lastItem {
            existing.onCancel()
        }

        let newItem = Item(id: UUID(), content: content, onCancel: onUserCancel)
        programmaticDismissID = nil
        item = newItem
        lastItem = newItem
        return Token(id: newItem.id)
    }

    public func dismiss(_ token: Token) {
        programmaticDismissID = token.id
        item = nil
    }

    fileprivate func handleCoverDismiss() {
        if item != nil {
            return
        }

        guard let lastItem else { return }
        defer { self.lastItem = nil }

        if programmaticDismissID == lastItem.id {
            programmaticDismissID = nil
            return
        }

        lastItem.onCancel()
        programmaticDismissID = nil
    }
}

private struct FullScreenCoverPresenterModifier<Presented: View>: ViewModifier {
    @ObservedObject var presenter: FullScreenCoverPresenter<Presented>

    func body(content: Content) -> some View {
        content.fullScreenCover(item: $presenter.item, onDismiss: {
            presenter.handleCoverDismiss()
        }) { item in
            item.content
        }
    }
}

public extension View {
    func fullScreenCoverPresenter<Presented: View>(_ presenter: FullScreenCoverPresenter<Presented>) -> some View {
        modifier(FullScreenCoverPresenterModifier(presenter: presenter))
    }
}
#endif

import SwiftUI

@MainActor
public final class SheetPresenter: ObservableObject, ModalPresenter {
    public struct Token: Hashable {
        fileprivate let id: UUID
    }

    struct Item: Identifiable {
        let id: UUID
        let content: AnyView
        let onCancel: () -> Void
    }

    @Published var item: Item?

    private var lastItem: Item?
    private var programmaticDismissID: UUID?

    public init() {}

    public func present<Content: View>(
        _ content: Content,
        onUserCancel: @escaping () -> Void
    ) -> Token {
        if let existing = lastItem {
            existing.onCancel()
        }

        let newItem = Item(id: UUID(), content: AnyView(content), onCancel: onUserCancel)
        programmaticDismissID = nil
        item = newItem
        lastItem = newItem
        return Token(id: newItem.id)
    }

    public func dismiss(_ token: Token) {
        programmaticDismissID = token.id
        item = nil
    }

    fileprivate func handleSheetDismiss() {
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

private struct SheetPresenterModifier: ViewModifier {
    @ObservedObject var presenter: SheetPresenter

    func body(content: Content) -> some View {
        content.sheet(item: $presenter.item, onDismiss: {
            presenter.handleSheetDismiss()
        }) { item in
            item.content
        }
    }
}

public extension View {
    func sheetPresenter(_ presenter: SheetPresenter) -> some View {
        modifier(SheetPresenterModifier(presenter: presenter))
    }
}

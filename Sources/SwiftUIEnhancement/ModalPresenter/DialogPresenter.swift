import SwiftUI

@available(iOS 15, macOS 12, tvOS 15, watchOS 8, *)
@MainActor
public final class DialogPresenter: ObservableObject, ModalPresenter {
    public struct Token: Hashable {
        fileprivate let id: UUID
    }

    struct Item {
        let id: UUID
        let actions: AnyView
        let onCancel: () -> Void
    }

    @Published var item: Item?

    public var title: LocalizedStringKey
    public var titleVisibility: Visibility
    public var message: AnyView

    private var programmaticDismissID: UUID?

    public init(
        title: LocalizedStringKey,
        titleVisibility: Visibility = .automatic,
        @ViewBuilder message: () -> some View = { EmptyView() }
    ) {
        self.title = title
        self.titleVisibility = titleVisibility
        self.message = AnyView(message())
    }

    public func present<Content: View>(
        _ content: Content,
        onUserCancel: @escaping () -> Void
    ) -> Token {
        if let existing = item {
            existing.onCancel()
        }

        let newItem = Item(id: UUID(), actions: AnyView(content), onCancel: onUserCancel)
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

@available(iOS 15, macOS 12, tvOS 15, watchOS 8, *)
private struct DialogPresenterModifier: ViewModifier {
    @ObservedObject var presenter: DialogPresenter

    func body(content: Content) -> some View {
        content.confirmationDialog(
            presenter.title,
            isPresented: presenter.binding(),
            titleVisibility: presenter.titleVisibility
        ) {
            if let item = presenter.item {
                item.actions
            } else {
                EmptyView()
            }
        } message: {
            presenter.message
        }
    }
}

@available(iOS 15, macOS 12, tvOS 15, watchOS 8, *)
public extension View {
    func dialogPresenter(_ presenter: DialogPresenter) -> some View {
        modifier(DialogPresenterModifier(presenter: presenter))
    }
}

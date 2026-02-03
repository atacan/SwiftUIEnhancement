import SwiftUI

@available(iOS 15, macOS 12, tvOS 15, watchOS 8, *)
@MainActor
public final class AlertPresenter<Actions: View, Message: View>: ObservableObject, ModalPresenter {
    public struct Token: Hashable {
        fileprivate let id: UUID
    }

    struct Item {
        let id: UUID
        let actions: Actions
        let onCancel: () -> Void
    }

    @Published var item: Item?

    public var title: LocalizedStringKey
    public var message: Message

    private var programmaticDismissID: UUID?

    public init(
        title: LocalizedStringKey,
        @ViewBuilder message: () -> Message
    ) {
        self.title = title
        self.message = message()
    }

    public convenience init(title: LocalizedStringKey) where Message == EmptyView {
        self.init(title: title, message: { EmptyView() })
    }

    public func present(
        _ content: Actions,
        onUserCancel: @escaping () -> Void
    ) -> Token {
        if let existing = item {
            existing.onCancel()
        }

        let newItem = Item(id: UUID(), actions: content, onCancel: onUserCancel)
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
private struct AlertPresenterModifier<Actions: View, Message: View>: ViewModifier {
    @ObservedObject var presenter: AlertPresenter<Actions, Message>

    func body(content: Content) -> some View {
        content.alert(presenter.title, isPresented: presenter.binding()) {
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
    func alertPresenter<Actions: View, Message: View>(_ presenter: AlertPresenter<Actions, Message>) -> some View {
        modifier(AlertPresenterModifier(presenter: presenter))
    }
}

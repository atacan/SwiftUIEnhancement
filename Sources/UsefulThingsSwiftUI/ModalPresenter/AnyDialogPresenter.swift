import SwiftUI

@available(iOS 15, macOS 12, tvOS 15, watchOS 8, *)
public typealias AnyDialogPresenter = DialogPresenter<AnyView, AnyView>

@available(iOS 15, macOS 12, tvOS 15, watchOS 8, *)
public extension DialogPresenter where Actions == AnyView, Message == AnyView {
    convenience init(
        title: LocalizedStringKey,
        titleVisibility: Visibility = .automatic,
        @ViewBuilder message: () -> some View = { EmptyView() }
    ) {
        self.init(title: title, titleVisibility: titleVisibility, message: { AnyView(message()) })
    }

    func present<V: View>(
        _ content: V,
        onUserCancel: @escaping () -> Void
    ) -> Token {
        present(AnyView(content), onUserCancel: onUserCancel)
    }
}

@available(iOS 15, macOS 12, tvOS 15, watchOS 8, *)
public extension View {
    func anyDialogPresenter(_ presenter: AnyDialogPresenter) -> some View {
        dialogPresenter(presenter)
    }
}

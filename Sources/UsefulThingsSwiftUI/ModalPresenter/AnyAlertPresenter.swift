import SwiftUI

@available(iOS 15, macOS 12, tvOS 15, watchOS 8, *)
public typealias AnyAlertPresenter = AlertPresenter<AnyView, AnyView>

@available(iOS 15, macOS 12, tvOS 15, watchOS 8, *)
public extension AlertPresenter where Actions == AnyView, Message == AnyView {
    convenience init(
        title: LocalizedStringKey,
        @ViewBuilder message: () -> some View = { EmptyView() }
    ) {
        self.init(title: title, message: { AnyView(message()) })
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
    func anyAlertPresenter(_ presenter: AnyAlertPresenter) -> some View {
        alertPresenter(presenter)
    }
}

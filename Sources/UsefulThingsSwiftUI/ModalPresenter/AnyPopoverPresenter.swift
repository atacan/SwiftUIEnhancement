#if os(iOS) || os(macOS)
import SwiftUI

public typealias AnyPopoverPresenter = PopoverPresenter<AnyView>

public extension PopoverPresenter where Content == AnyView {
    func present<V: View>(
        _ content: V,
        onUserCancel: @escaping () -> Void
    ) -> Token {
        present(AnyView(content), onUserCancel: onUserCancel)
    }
}

public extension View {
    func anyPopoverPresenter(_ presenter: AnyPopoverPresenter) -> some View {
        popoverPresenter(presenter)
    }
}
#endif

#if os(iOS)
import SwiftUI

public typealias AnyFullScreenCoverPresenter = FullScreenCoverPresenter<AnyView>

public extension FullScreenCoverPresenter where Content == AnyView {
    func present<V: View>(
        _ content: V,
        onUserCancel: @escaping () -> Void
    ) -> Token {
        present(AnyView(content), onUserCancel: onUserCancel)
    }
}

public extension View {
    func anyFullScreenCoverPresenter(_ presenter: AnyFullScreenCoverPresenter) -> some View {
        fullScreenCoverPresenter(presenter)
    }
}
#endif

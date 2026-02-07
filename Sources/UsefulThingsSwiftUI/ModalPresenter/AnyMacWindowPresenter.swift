#if os(macOS)
import SwiftUI

public typealias AnyMacWindowPresenter = MacWindowPresenter<AnyView>

public extension MacWindowPresenter where Content == AnyView {
    func present<V: View>(
        _ content: V,
        onUserCancel: @escaping () -> Void
    ) -> Token {
        present(AnyView(content), onUserCancel: onUserCancel)
    }
}
#endif

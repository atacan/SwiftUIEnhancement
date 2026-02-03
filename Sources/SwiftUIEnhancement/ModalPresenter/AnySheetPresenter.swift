import SwiftUI

public typealias AnySheetPresenter = SheetPresenter<AnyView>

public extension SheetPresenter where Content == AnyView {
    func present<V: View>(
        _ content: V,
        onUserCancel: @escaping () -> Void
    ) -> Token {
        present(AnyView(content), onUserCancel: onUserCancel)
    }
}

public extension View {
    func anySheetPresenter(_ presenter: AnySheetPresenter) -> some View {
        sheetPresenter(presenter)
    }
}

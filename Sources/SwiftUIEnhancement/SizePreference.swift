import SwiftUI

public struct SizePreferenceKey: PreferenceKey {
    public static var defaultValue: CGSize = .zero
    public static func reduce(value: inout CGSize, nextValue: () -> CGSize) { value = nextValue() }
}

struct UpdateSizePreferenceKeyModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader { geometryProxy in
                    Color.clear
                        .preference(key: SizePreferenceKey.self, value: geometryProxy.size)
                }
            )
    }
}

extension View {
    public func updateSizePreferenceKey() -> some View {
        self.modifier(UpdateSizePreferenceKeyModifier())
    }
}

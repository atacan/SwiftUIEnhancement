import SwiftUI

/// ScrollView(.horizontal or ScrollView(.vertical depending on `axis`
struct DynamicScrollView<Content: View>: View {
    let axis: Axis.Set
    let showsIndicators: Bool
    let content: Content

    init(
        axis: Axis.Set = .vertical,
        showsIndicators: Bool = true,
        @ViewBuilder content: () -> Content
    ) {
        self.axis = axis
        self.showsIndicators = showsIndicators
        self.content = content()
    }

    var body: some View {
        if axis == .horizontal {
            ScrollView(.horizontal, showsIndicators: showsIndicators, content: { content })
        } else if axis == .vertical {
            ScrollView(.vertical, showsIndicators: showsIndicators, content: { content })
        }
    }
}

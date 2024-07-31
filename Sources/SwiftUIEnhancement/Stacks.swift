import SwiftUI

/// HStack or VStack changed by `axis`
public struct DynamicStack<Content: View>: View {
    let axis: Axis.Set
    let verticalAlignment: VerticalAlignment
    let horizontalAlignment: HorizontalAlignment
    let spacing: CGFloat?
    let content: Content

    public init(
        axis: Axis.Set = .horizontal,
        verticalAlignment: VerticalAlignment = .center,
        horizontalAlignment: HorizontalAlignment = .center,
        spacing: CGFloat? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.axis = axis
        self.verticalAlignment = verticalAlignment
        self.horizontalAlignment = horizontalAlignment
        self.spacing = spacing
        self.content = content()
    }

    public var body: some View {
        if axis == .horizontal {
            HStack(alignment: verticalAlignment, spacing: spacing, content: { content })
        } else if axis == .vertical {
            VStack(alignment: horizontalAlignment, spacing: spacing, content: { content })
        }
    }
}

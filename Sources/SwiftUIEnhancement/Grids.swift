import SwiftUI

/// LazyHGrid or LazyVGrid depending on `axis`
public struct DynamicLazyGrid<Content: View>: View {
    public let axis: Axis.Set
    public let columns: [GridItem]
    public let spacing: CGFloat?
    public let pinnedViews: PinnedScrollableViews
    public let content: Content

    public init(
        axis: Axis.Set = .vertical,
        columns: [GridItem],
        spacing: CGFloat? = nil,
        pinnedViews: PinnedScrollableViews = .init(),
        @ViewBuilder content: () -> Content
    ) {
        self.axis = axis
        self.columns = columns
        self.spacing = spacing
        self.pinnedViews = pinnedViews
        self.content = content()
    }

    public var body: some View {
        if axis == .horizontal {
            LazyHGrid(rows: columns, spacing: spacing, pinnedViews: pinnedViews, content: { content })
        } else if axis == .vertical {
            LazyVGrid(columns: columns, spacing: spacing, pinnedViews: pinnedViews, content: { content })
        }
    }
}

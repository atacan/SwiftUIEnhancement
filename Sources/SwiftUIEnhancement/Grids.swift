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

#Preview("Dynamic Lazy Grid") {
    struct GridDemo: View {
        @State private var axis: Axis.Set = .vertical
        
        var body: some View {
            VStack {
                Picker("Axis", selection: $axis) {
                    Text("Vertical").tag(Axis.Set.vertical)
                    Text("Horizontal").tag(Axis.Set.horizontal)
                }
                .pickerStyle(.segmented)
                .padding()
                
                ScrollView(axis == .horizontal ? .horizontal : .vertical) {
                    DynamicLazyGrid(
                        axis: axis,
                        columns: Array(repeating: GridItem(.flexible()), count: 3),
                        spacing: 10
                    ) {
                        ForEach(1...20, id: \.self) { index in
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.blue.opacity(0.7))
                                .frame(width: 80, height: 80)
                                .overlay(Text("\(index)").foregroundColor(.white))
                        }
                    }
                }
                .frame(maxHeight: 400)
            }
        }
    }
    
    return GridDemo()
}

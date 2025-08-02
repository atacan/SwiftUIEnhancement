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

#Preview("Dynamic Stack") {
    struct StackDemo: View {
        @State private var axis: Axis.Set = .horizontal
        @State private var spacing: CGFloat = 10
        
        var body: some View {
            VStack(spacing: 20) {
                VStack {
                    Text("Dynamic Stack Demo")
                        .font(.headline)
                    
                    Picker("Layout", selection: $axis) {
                        Text("Horizontal").tag(Axis.Set.horizontal)
                        Text("Vertical").tag(Axis.Set.vertical)
                    }
                    .pickerStyle(.segmented)
                    
                    HStack {
                        Text("Spacing: \(Int(spacing))")
                        Slider(value: $spacing, in: 0...30)
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)
                
                DynamicStack(
                    axis: axis,
                    spacing: spacing
                ) {
                    ForEach(1...5, id: \.self) { index in
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.blue.opacity(0.7))
                            .frame(width: 60, height: 60)
                            .overlay(
                                Text("\(index)")
                                    .foregroundColor(.white)
                                    .fontWeight(.bold)
                            )
                    }
                }
                .padding()
                .background(Color.blue.opacity(0.1))
                .cornerRadius(12)
                
                VStack {
                    Text("Alignment Examples")
                        .font(.headline)
                    
                    VStack(spacing: 15) {
                        DynamicStack(
                            axis: .horizontal,
                            verticalAlignment: .top,
                            spacing: 10
                        ) {
                            Text("Top")
                                .padding()
                                .background(Color.red.opacity(0.3))
                            Text("Aligned\nMulti-line")
                                .padding()
                                .background(Color.green.opacity(0.3))
                            Text("Items")
                                .padding()
                                .background(Color.blue.opacity(0.3))
                        }
                        
                        DynamicStack(
                            axis: .vertical,
                            horizontalAlignment: .leading,
                            spacing: 5
                        ) {
                            Text("Leading")
                                .padding()
                                .background(Color.orange.opacity(0.3))
                            Text("Aligned")
                                .padding()
                                .background(Color.purple.opacity(0.3))
                            Text("Vertical Items")
                                .padding()
                                .background(Color.blue.opacity(0.3))
                        }
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)
            }
            .padding()
        }
    }
    
    return StackDemo()
}

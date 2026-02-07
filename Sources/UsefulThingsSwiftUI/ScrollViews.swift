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

#Preview("Dynamic ScrollView") {
    struct ScrollViewDemo: View {
        @State private var axis: Axis.Set = .vertical
        @State private var showsIndicators = true
        
        var body: some View {
            VStack(spacing: 20) {
                Text("Dynamic ScrollView Demo")
                    .font(.headline)
                
                VStack {
                    Picker("Scroll Direction", selection: $axis) {
                        Text("Vertical").tag(Axis.Set.vertical)
                        Text("Horizontal").tag(Axis.Set.horizontal)
                    }
                    .pickerStyle(.segmented)
                    
                    Toggle("Show Indicators", isOn: $showsIndicators)
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
                
                DynamicScrollView(
                    axis: axis,
                    showsIndicators: showsIndicators
                ) {
                    if axis == .horizontal {
                        HStack(spacing: 15) {
                            ForEach(1...20, id: \.self) { index in
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.blue.opacity(0.7))
                                    .frame(width: 120, height: 80)
                                    .overlay(
                                        VStack {
                                            Text("Item \(index)")
                                                .fontWeight(.semibold)
                                                .foregroundColor(.white)
                                            Text("Horizontal")
                                                .font(.caption)
                                                .foregroundColor(.white.opacity(0.8))
                                        }
                                    )
                            }
                        }
                        .padding()
                    } else {
                        VStack(spacing: 15) {
                            ForEach(1...20, id: \.self) { index in
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.green.opacity(0.7))
                                    .frame(height: 80)
                                    .overlay(
                                        HStack {
                                            VStack(alignment: .leading) {
                                                Text("Item \(index)")
                                                    .fontWeight(.semibold)
                                                    .foregroundColor(.white)
                                                Text("Vertical scrolling content")
                                                    .font(.caption)
                                                    .foregroundColor(.white.opacity(0.8))
                                            }
                                            Spacer()
                                            Image(systemName: "arrow.down")
                                                .foregroundColor(.white)
                                        }
                                        .padding()
                                    )
                            }
                        }
                        .padding()
                    }
                }
                .frame(height: 300)
                .background(Color.gray.opacity(0.05))
                .cornerRadius(12)
                
                Text("Scroll direction and indicators can be changed dynamically")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding()
        }
    }
    
    return ScrollViewDemo()
}

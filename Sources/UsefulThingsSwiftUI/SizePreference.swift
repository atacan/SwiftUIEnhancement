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

#Preview("Size Preference Demo") {
    struct SizePreferenceDemo: View {
        @State private var capturedSize: CGSize = .zero
        @State private var text = "Resize me!"
        
        var body: some View {
            VStack(spacing: 20) {
                Text("Size Preference Key Demo")
                    .font(.headline)
                
                VStack {
                    TextField("Enter text to resize", text: $text)
                        .textFieldStyle(.roundedBorder)
                    
                    Text("Size: \(Int(capturedSize.width)) x \(Int(capturedSize.height))")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(Color.blue.opacity(0.1))
                .cornerRadius(8)
                
                Text(text)
                    .font(.title)
                    .fontWeight(.bold)
                    .padding()
                    .background(Color.green.opacity(0.3))
                    .cornerRadius(12)
                    .updateSizePreferenceKey()
                    .onPreferenceChange(SizePreferenceKey.self) { size in
                        capturedSize = size
                    }
                
                VStack {
                    Text("Dynamic Content")
                        .font(.headline)
                    
                    VStack(spacing: 10) {
                        ForEach(0..<3) { index in
                            HStack {
                                Image(systemName: "star.fill")
                                Text("Item \(index + 1)")
                                Spacer()
                                Text("\(Int.random(in: 10...100))")
                            }
                            .padding()
                            .background(Color.orange.opacity(0.3))
                            .cornerRadius(8)
                        }
                    }
                    .updateSizePreferenceKey()
                    .onPreferenceChange(SizePreferenceKey.self) { size in
                        print("Dynamic content size: \(size)")
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)
                
                Text("The SizePreferenceKey captures view sizes and can be used for responsive layouts")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding()
        }
    }
    
    return SizePreferenceDemo()
}

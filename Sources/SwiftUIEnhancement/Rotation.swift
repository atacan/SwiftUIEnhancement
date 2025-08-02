import SwiftUI

private struct SizeKey: PreferenceKey {
    static let defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}

extension View {
    func captureSize(in binding: Binding<CGSize>) -> some View {
        overlay(
            GeometryReader { proxy in
                Color.clear.preference(key: SizeKey.self, value: proxy.size)
            }
        )
        .onPreferenceChange(SizeKey.self) { size in binding.wrappedValue = size }
    }
}

struct Rotated<Rotated: View>: View {
    var view: Rotated
    var angle: Angle

    init(_ view: Rotated, angle: Angle = .degrees(-90)) {
        self.view = view
        self.angle = angle
    }

    @State private var size: CGSize = .zero

    var body: some View {
        // Rotate the frame, and compute the smallest integral frame that contains it
        let newFrame = CGRect(origin: .zero, size: size)
            .offsetBy(dx: -size.width / 2, dy: -size.height / 2)
            .applying(.init(rotationAngle: CGFloat(angle.radians)))
            .integral

        return
            view
                .fixedSize() // Don't change the view's ideal frame
                .captureSize(in: $size) // Capture the size of the view's ideal frame
                .rotationEffect(angle) // Rotate the view
                .frame(
                    width: newFrame.width, // And apply the new frame
                    height: newFrame.height
                )
    }
}

extension View {
    public func rotated(_ angle: Angle = .degrees(-90)) -> some View {
        Rotated(self, angle: angle)
    }
}

#Preview("Rotation Demo") {
    VStack(spacing: 30) {
        Text("Rotation Examples")
            .font(.largeTitle)
            .fontWeight(.bold)
        
        HStack(spacing: 30) {
            VStack {
                Text("Original")
                    .font(.caption)
                Rectangle()
                    .fill(Color.blue)
                    .frame(width: 60, height: 40)
                    .overlay(Text("Text").foregroundColor(.white))
            }
            
            VStack {
                Text("-90°")
                    .font(.caption)
                Rectangle()
                    .fill(Color.red)
                    .frame(width: 60, height: 40)
                    .overlay(Text("Text").foregroundColor(.white))
                    .rotated(.degrees(-90))
            }
            
            VStack {
                Text("45°")
                    .font(.caption)
                Rectangle()
                    .fill(Color.green)
                    .frame(width: 60, height: 40)
                    .overlay(Text("Text").foregroundColor(.white))
                    .rotated(.degrees(45))
            }
        }
        
        HStack(spacing: 30) {
            VStack {
                Text("90°")
                    .font(.caption)
                Rectangle()
                    .fill(Color.orange)
                    .frame(width: 60, height: 40)
                    .overlay(Text("Text").foregroundColor(.white))
                    .rotated(.degrees(90))
            }
            
            VStack {
                Text("180°")
                    .font(.caption)
                Rectangle()
                    .fill(Color.purple)
                    .frame(width: 60, height: 40)
                    .overlay(Text("Text").foregroundColor(.white))
                    .rotated(.degrees(180))
            }
            
            VStack {
                Text("270°")
                    .font(.caption)
                Rectangle()
                    .fill(Color.blue)
                    .frame(width: 60, height: 40)
                    .overlay(Text("Text").foregroundColor(.white))
                    .rotated(.degrees(270))
            }
        }
        
        VStack {
            Text("Complex Shape Rotation")
                .font(.headline)
            
            HStack(spacing: 20) {
                Image(systemName: "arrow.right")
                    .font(.system(size: 30))
                    .foregroundColor(.blue)
                
                Image(systemName: "arrow.right")
                    .font(.system(size: 30))
                    .foregroundColor(.red)
                    .rotated(.degrees(45))
                
                Image(systemName: "arrow.right")
                    .font(.system(size: 30))
                    .foregroundColor(.green)
                    .rotated(.degrees(90))
                
                Image(systemName: "arrow.right")
                    .font(.system(size: 30))
                    .foregroundColor(.orange)
                    .rotated(.degrees(135))
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
    }
    .padding()
}

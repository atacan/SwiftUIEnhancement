import SwiftUI

public struct CircularProgressView: View {
    private let value: Double
    
    public init(value: Double) {
        self.value = value
    }
    
    public var body: some View {
        Circle()
            .trim(from: 0, to: CGFloat(self.value))
            .stroke(style: StrokeStyle(lineWidth: 2, lineCap: .round))
            .rotationEffect(.degrees(-90))
            .animation(.easeIn, value: self.value)
    }
}

#Preview {
    CircularProgressView(value: 0.3).frame(width: 44, height: 44)
}

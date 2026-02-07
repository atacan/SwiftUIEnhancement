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

#Preview("Circular Progress View") {
    VStack(spacing: 20) {
        Text("Circular Progress View Demo")
            .font(.headline)
        
        HStack(spacing: 20) {
            VStack {
                CircularProgressView(value: 0.25)
                    .frame(width: 60, height: 60)
                    .foregroundColor(.red)
                Text("25%")
                    .font(.caption)
            }
            
            VStack {
                CircularProgressView(value: 0.5)
                    .frame(width: 60, height: 60)
                    .foregroundColor(.orange)
                Text("50%")
                    .font(.caption)
            }
            
            VStack {
                CircularProgressView(value: 0.75)
                    .frame(width: 60, height: 60)
                    .foregroundColor(.blue)
                Text("75%")
                    .font(.caption)
            }
            
            VStack {
                CircularProgressView(value: 1.0)
                    .frame(width: 60, height: 60)
                    .foregroundColor(.green)
                Text("100%")
                    .font(.caption)
            }
        }
        
        VStack {
            Text("Different Sizes")
                .font(.headline)
            
            HStack(spacing: 15) {
                CircularProgressView(value: 0.6)
                    .frame(width: 30, height: 30)
                    .foregroundColor(.purple)
                
                CircularProgressView(value: 0.6)
                    .frame(width: 50, height: 50)
                    .foregroundColor(.blue)
                
                CircularProgressView(value: 0.6)
                    .frame(width: 70, height: 70)
                    .foregroundColor(.pink)
                
                CircularProgressView(value: 0.6)
                    .frame(width: 90, height: 90)
                    .foregroundColor(.green)
            }
        }
        
        VStack {
            Text("Animated Progress")
                .font(.headline)
            
            AnimatedProgressDemo()
        }
    }
    .padding()
}

struct AnimatedProgressDemo: View {
    @State private var progress: Double = 0.0
    
    var body: some View {
        VStack(spacing: 15) {
            CircularProgressView(value: progress)
                .frame(width: 80, height: 80)
                .foregroundColor(.purple)
            
            Text("\(Int(progress * 100))%")
                .font(.title2)
                .fontWeight(.semibold)
            
            Button("Animate") {
                withAnimation(.easeInOut(duration: 2.0)) {
                    progress = progress < 1.0 ? 1.0 : 0.0
                }
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
    }
}

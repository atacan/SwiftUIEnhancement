import SwiftUI

@available(macOS 14.0, iOS 17.0, *)
public struct SplashingButton: View {
    @State private var heartCount = 0
    @State private var isLoved = false
    
    let imageSystemName: String
    let action: ()->Void
    
    public init(imageSystemName: String, action: @escaping () -> Void) {
        self.imageSystemName = imageSystemName
        self.action = action
    }
    
    public var body: some View {
        Button {
            self.action()
            
            heartCount += 1
            
            withAnimation(.interpolatingSpring(stiffness: 170, damping: 5)) {
                isLoved.toggle()
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.45) {
                withAnimation(.interpolatingSpring(stiffness: 170, damping: 10)) {
                    isLoved = false
                }
            }
        } label: {
            ZStack {
                Circle()
                    .strokeBorder(lineWidth: isLoved ? 0 : 4)
                    .animation(.easeInOut(duration: 0.5).delay(0.1),value: isLoved)
//                    .frame(width: 70, height: 70)
                    .foregroundColor(Color(.systemPink))
                    .hueRotation(.degrees(isLoved ? 300 : 200))
                    .scaleEffect(isLoved ? 1.15 : 0)
                    .animation(.easeInOut(duration: 0.5), value: isLoved)
                
                SplashView()
                    .opacity(isLoved ? 0 : 1)
                    .animation(.easeInOut(duration: 0.5).delay(0.25), value: isLoved)
                    .scaleEffect(isLoved ? 1.25 : 0)
                    .animation(.easeInOut(duration: 0.5), value: isLoved)
                
                SplashView()
                    .rotationEffect(.degrees(90))
                    .opacity(isLoved ? 0 : 1)
                    .offset(y: isLoved ? 6 : -6)
                    .animation(.easeInOut(duration: 0.5).delay(0.2), value: isLoved)
                    .scaleEffect(isLoved ? 1.25 : 0)
                    .animation(.easeOut(duration: 0.5), value: isLoved)
                Image(systemName: imageSystemName)
//                    .foregroundStyle(Color.red)
                    .phaseAnimator([false, true], trigger: heartCount) { icon, scaleFromBottom in
                        icon
                            .scaleEffect(scaleFromBottom ? 1.5 : 1, anchor: .bottom)
                    } animation: { scaleFromBottom in
                            .bouncy(duration: 0.4, extraBounce: 0.4)
                    }
            }
        }
    }
}

struct SplashView: View {
    @State private var innerGap = true
    let streamBlue = Color(#colorLiteral(red: 0, green: 0.3725490196, blue: 1, alpha: 1))
    
    var body: some View {
        ZStack {
            ForEach(0..<8) {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [.green, .red],
                            startPoint: .bottom,
                            endPoint: .leading
                        )
                    )
                    .frame(width: 3, height: 3)
                    .offset(x: innerGap ? 24 : 0)
                    .rotationEffect(.degrees(Double($0) * 45))
                    .hueRotation(.degrees(300))
            }
            
            ForEach(0..<8) {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [.green, streamBlue],
                            startPoint: .bottom,
                            endPoint: .leading
                        )
                    )
                    .frame(width: 4, height: 4)
                    .offset(x: innerGap ? 26 : 0)
                    .rotationEffect(.degrees(Double($0) * 45))
                    .hueRotation(.degrees(60))
                
            }
            .rotationEffect(.degrees(12))
        }
    }
}

#Preview("Splash View Demo") {
    VStack(spacing: 30) {
        Text("Splash View Components")
            .font(.largeTitle)
            .fontWeight(.bold)
        
        VStack(spacing: 20) {
            Text("SplashingButton")
                .font(.headline)
            
            HStack(spacing: 20) {
                if #available(macOS 14.0, iOS 17.0, *) {
                    SplashingButton(imageSystemName: "heart.fill") {
                        print("Heart button tapped!")
                    }
                    .foregroundColor(.red)
                    
                    SplashingButton(imageSystemName: "star.fill") {
                        print("Star button tapped!")
                    }
                    .foregroundColor(.yellow)
                    
                    SplashingButton(imageSystemName: "thumbs.up.fill") {
                        print("Thumbs up button tapped!")
                    }
                    .foregroundColor(.blue)
                } else {
                    Text("SplashingButton requires macOS 14.0+ or iOS 17.0+")
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding()
        .background(Color.blue.opacity(0.1))
        .cornerRadius(12)
        
        VStack(spacing: 20) {
            Text("Standalone Splash Effects")
                .font(.headline)
            
            HStack(spacing: 30) {
                VStack {
                    Text("Default Colors")
                        .font(.caption)
                    SplashView()
                        .frame(width: 60, height: 60)
                }
                
                VStack {
                    Text("Large Size")
                        .font(.caption)
                    SplashView()
                        .frame(width: 100, height: 100)
                        .scaleEffect(1.5)
                }
                
                VStack {
                    Text("With Background")
                        .font(.caption)
                    SplashView()
                        .frame(width: 80, height: 80)
                        .background(Color.black.opacity(0.1))
                        .cornerRadius(40)
                }
            }
        }
        .padding()
        .background(Color.green.opacity(0.1))
        .cornerRadius(12)
        
        if #available(macOS 14.0, iOS 17.0, *) {
            VStack {
                Text("Interactive Demo")
                    .font(.headline)
                
                Text("Tap the buttons above to see the splash animation effect!")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding()
            .background(Color.orange.opacity(0.1))
            .cornerRadius(12)
        }
        
        VStack {
            Text("Features")
                .font(.headline)
            
            VStack(alignment: .leading, spacing: 5) {
                Text("• Animated splash particles")
                Text("• Customizable colors and gradients")
                Text("• Bounce animation with phase animator")
                Text("• Perfect for like/favorite buttons")
            }
            .font(.subheadline)
            .foregroundColor(.secondary)
        }
        .padding()
        .background(Color.purple.opacity(0.1))
        .cornerRadius(12)
    }
    .padding()
}

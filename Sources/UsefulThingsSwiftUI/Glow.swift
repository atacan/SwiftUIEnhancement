import SwiftUI

extension View {
    /// `.glow(color: .blue, radius: 36)`
    public func glow(color: Color = .red, radius: CGFloat = 20) -> some View {
        shadow(color: color, radius: radius / 3)
            .shadow(color: color, radius: radius / 3)
            .shadow(color: color, radius: radius / 3)
    }

    public func glowBlurry(color: Color = .red, radius: CGFloat = 20) -> some View {
        overlay(blur(radius: radius / 6))
            .shadow(color: color, radius: radius / 3)
            .shadow(color: color, radius: radius / 3)
            .shadow(color: color, radius: radius / 3)
    }

    public func multicolorGlow() -> some View {
        ZStack {
            ForEach(0 ..< 2) { i in
                Rectangle()
                    .fill(AngularGradient(
                        gradient: Gradient(colors: [.red, .yellow, .green, .blue, .purple, .red]),
                        center: .center
                    ))
                    .frame(width: 400, height: 300)
                    .mask(self.blur(radius: 20))
                    .overlay(self.blur(radius: 5 - CGFloat(i * 5)))
            }
        }
    }

    /// ```swift
    /// Circle()
    ///    .fill(Color.green)
    ///    .frame(width: 300, height: 300)
    ///    .innerShadow(using: Circle())
    /// ```
    public func innerShadow(
        using shape: some Shape,
        angle: Angle = .degrees(0),
        color: Color = .black,
        width: CGFloat = 6,
        blur: CGFloat = 6
    ) -> some View {
        let finalX = CGFloat(cos(angle.radians - .pi / 2))
        let finalY = CGFloat(sin(angle.radians - .pi / 2))

        return overlay(
            shape
                .stroke(color, lineWidth: width)
                .offset(x: finalX * width * 0.6, y: finalY * width * 0.6)
                .blur(radius: blur)
                .mask(shape)
        )
    }
}

#Preview("Glow Effects") {
    ScrollView {
        VStack(spacing: 30) {
            VStack {
                Text("Basic Glow Effects")
                    .font(.headline)
                
                HStack(spacing: 20) {
                    Text("Red Glow")
                        .padding()
                        .background(Color.black)
                        .foregroundColor(.white)
                        .glow(color: .red, radius: 20)
                    
                    Text("Blue Glow")
                        .padding()
                        .background(Color.black)
                        .foregroundColor(.white)
                        .glow(color: .blue, radius: 30)
                    
                    Text("Green Glow")
                        .padding()
                        .background(Color.black)
                        .foregroundColor(.white)
                        .glow(color: .green, radius: 25)
                }
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(12)
            
            VStack {
                Text("Blurry Glow Effects")
                    .font(.headline)
                
                HStack(spacing: 20) {
                    Circle()
                        .fill(Color.yellow)
                        .frame(width: 60, height: 60)
                        .glowBlurry(color: .orange, radius: 40)
                    
                    Rectangle()
                        .fill(Color.purple)
                        .frame(width: 60, height: 60)
                        .glowBlurry(color: .pink, radius: 35)
                    
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.blue)
                        .frame(width: 60, height: 60)
                        .glowBlurry(color: .blue, radius: 30)
                }
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(12)
            
            VStack {
                Text("Multicolor Glow")
                    .font(.headline)
                
                Text("AMAZING")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multicolorGlow()
            }
            .padding()
            .background(Color.black)
            .cornerRadius(12)
            
            VStack {
                Text("Inner Shadow Effects")
                    .font(.headline)
                
                HStack(spacing: 20) {
                    Circle()
                        .fill(Color.green)
                        .frame(width: 80, height: 80)
                        .innerShadow(using: Circle())
                    
                    Rectangle()
                        .fill(Color.blue)
                        .frame(width: 80, height: 80)
                        .innerShadow(using: Rectangle(), color: .red, width: 4, blur: 8)
                    
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.orange)
                        .frame(width: 80, height: 80)
                        .innerShadow(using: RoundedRectangle(cornerRadius: 20), angle: .degrees(45))
                }
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(12)
        }
        .padding()
    }
}

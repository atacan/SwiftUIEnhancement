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

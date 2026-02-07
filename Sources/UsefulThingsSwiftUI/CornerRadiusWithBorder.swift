import SwiftUI

public struct ModifierCornerRadiusWithBorder: ViewModifier {
    var radius: CGFloat
    var borderLineWidth: CGFloat = 1
    var borderColor: Color = .gray
    var antialiased: Bool = true

    public init(radius: CGFloat, borderLineWidth: CGFloat, borderColor: Color, antialiased: Bool) {
        self.radius = radius
        self.borderLineWidth = borderLineWidth
        self.borderColor = borderColor
        self.antialiased = antialiased
    }

    public func body(content: Content) -> some View {
        content
            .cornerRadius(radius, antialiased: antialiased)
            .overlay(
                RoundedRectangle(cornerRadius: radius)
                    .inset(by: borderLineWidth)
                    .strokeBorder(borderColor, lineWidth: borderLineWidth, antialiased: antialiased)
            )
    }
}

extension View {
    public func cornerRadiusWithBorder(
        radius: CGFloat,
        borderLineWidth: CGFloat = 1,
        borderColor: Color = .gray,
        antialiased: Bool = true
    ) -> some View {
        modifier(ModifierCornerRadiusWithBorder(
            radius: radius,
            borderLineWidth: borderLineWidth,
            borderColor: borderColor,
            antialiased: antialiased
        ))
    }
}

#Preview("Corner Radius with Border") {
    VStack(spacing: 20) {
        Rectangle()
            .fill(Color.blue)
            .frame(width: 100, height: 100)
            .cornerRadiusWithBorder(radius: 10)
        
        Rectangle()
            .fill(Color.green)
            .frame(width: 100, height: 100)
            .cornerRadiusWithBorder(radius: 20, borderLineWidth: 3, borderColor: .red)
        
        Text("Hello World")
            .padding()
            .background(Color.yellow)
            .cornerRadiusWithBorder(radius: 15, borderLineWidth: 2, borderColor: .purple)
        
        Image(systemName: "star.fill")
            .font(.system(size: 50))
            .foregroundColor(.orange)
            .padding()
            .cornerRadiusWithBorder(radius: 25, borderLineWidth: 4, borderColor: .black)
    }
    .padding()
}

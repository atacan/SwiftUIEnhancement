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

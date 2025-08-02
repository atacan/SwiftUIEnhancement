import SwiftUI

#if os(macOS)
extension Color {
    public var data: Data? {
        try? NSKeyedArchiver.archivedData(withRootObject: NSColor(self), requiringSecureCoding: false)
    }

    public init?(data: Data?) {
        guard let data,
              //              let color = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? Color
              let color = try? NSKeyedUnarchiver.unarchivedObject(ofClass: NSColor.self, from: data)
        else {
            return nil
        }
        self = .init(nsColor: color)
    }
}
#endif

#if os(iOS)
@available(iOS 15.0, *)
extension Color {
    public var data: Data? {
        try? NSKeyedArchiver.archivedData(withRootObject: UIColor(self), requiringSecureCoding: false)
    }

    public init?(data: Data?) {
        guard let data,
              let color = try? NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: data)
        else {
            return nil
        }
        self = .init(uiColor: color)
    }
}
#endif

public struct CodableCGColor: Codable, Sendable {
    public var cgColor: CGColor

    @available(iOS 15.0, macOS 11.0, *)
    public var swiftuiColor: Color {
        get {
            Color(cgColor: cgColor)
        }
        set {
            if let new = newValue.cgColor {
                cgColor = new
            }
        }
    }

    enum CodingKeys: String, CodingKey {
        case colorSpace
        case components
    }

    public init(cgColor: CGColor) {
        self.cgColor = cgColor
    }

    @available(iOS 14.0, macOS 11.0, *)
    public init?(color: Color) {
        guard let cgColor = color.cgColor else {
            return nil
        }
        self.cgColor = cgColor
    }

    public init(from decoder: Decoder) throws {
        let container =
            try decoder
                .container(keyedBy: CodingKeys.self)
        let colorSpace =
            try container
                .decode(String.self, forKey: .colorSpace)
        let components =
            try container
                .decode([CGFloat].self, forKey: .components)

        guard let cgColorSpace = CGColorSpace(name: colorSpace as CFString),
              let cgColor = CGColor(
                  colorSpace: cgColorSpace,
                  components: components
              )
        else {
            throw CodingError.wrongData
        }

        self.cgColor = cgColor
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        guard let colorSpace = cgColor.colorSpace?.name,
              let components = cgColor.components
        else {
            throw CodingError.wrongData
        }

        try container.encode(colorSpace as String, forKey: .colorSpace)
        try container.encode(components, forKey: .components)
    }
}

enum CodingError: Error, LocalizedError {
    case wrongColor
    case wrongData

    var errorDescription: String? {
        switch self {
        case .wrongColor:
            return "Color is wrong"
        case .wrongData:
            return "Color Data is wrong"
        }
    }
}

extension CodableCGColor: Hashable {}

extension CodableCGColor: Equatable {}

extension CodableCGColor {
    public static func random() -> CodableCGColor {
        let red = Double.random(in: 0 ... 1)
        let green = Double.random(in: 0 ... 1)
        let blue = Double.random(in: 0 ... 1)
        return .init(cgColor: .init(red: red, green: green, blue: blue, alpha: 1))
    }

    public func bestForegroundColor() -> CodableCGColor {
        guard let components = cgColor.components else {
            return .init(cgColor: .init(red: 0.81, green: 0.81, blue: 0.81, alpha: 1.00))
        }
        let red = components[0]
        let green = components[1]
        let blue = components[2]
        let luminance = 0.299 * red + 0.587 * green + 0.114 * blue

        let blackContrast = contrastRatio(luminance1: luminance, luminance2: 0)
        let whiteContrast = contrastRatio(luminance1: luminance, luminance2: 1)

        // Choose white or black based on which has a higher contrast ratio
        if whiteContrast >= 4.5 || blackContrast < 4.5 {
            return .init(cgColor: .init(red: 0.91, green: 0.91, blue: 0.95, alpha: 1.00))
        } else {
            return .init(cgColor: .init(red: 0.07, green: 0.07, blue: 0.10, alpha: 1.00))
        }
    }

    public static func randomBGFG() -> (bg: CodableCGColor, fg: CodableCGColor) {
        let bg = Self.random()
        let fg = bg.bestForegroundColor()
        return (bg, fg)
    }

    func contrastRatio(luminance1: Double, luminance2: Double) -> Double {
        let l1 = max(luminance1, luminance2)
        let l2 = min(luminance1, luminance2)
        return (l1 + 0.05) / (l2 + 0.05)
    }
}

// Helper extension to modify brightness of a Color
#if os(macOS)
extension Color {
    public func brighter(by percentage: CGFloat = 0.1) -> Color {
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0

        let nsColor = NSColor(self)
        nsColor.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)

        let newBrightness = min(brightness + percentage, 1.0) // Clamp brightness to 1.0

        return Color(nsColor: NSColor(hue: hue, saturation: saturation, brightness: newBrightness, alpha: alpha))
    }

    public func darker(by percentage: CGFloat = 0.2) -> Color { // Added a similar helper for darkening
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0

        let nsColor = NSColor(self)
        nsColor.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)

        let newBrightness = max(brightness - percentage, 0.0) // Clamp brightness to 0.0

        return Color(nsColor: NSColor(hue: hue, saturation: saturation, brightness: newBrightness, alpha: alpha))
    }
}
#endif

#if os(iOS)
@available(iOS 15.0, *)
extension Color {
    public func brighter(by percentage: CGFloat = 0.1) -> Color {
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0

        let uiColor = UIColor(self)
        uiColor.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)

        let newBrightness = min(brightness + percentage, 1.0) // Clamp brightness to 1.0

        return Color(uiColor: UIColor(hue: hue, saturation: saturation, brightness: newBrightness, alpha: alpha))
    }

    public func darker(by percentage: CGFloat = 0.2) -> Color { // Added a similar helper for darkening
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0

        let uiColor = UIColor(self)
        uiColor.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)

        let newBrightness = max(brightness - percentage, 0.0) // Clamp brightness to 0.0

        return Color(uiColor: UIColor(hue: hue, saturation: saturation, brightness: newBrightness, alpha: alpha))
    }
}
#endif

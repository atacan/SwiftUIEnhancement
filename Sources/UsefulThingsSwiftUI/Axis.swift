import SwiftUI

extension Axis.Set: @retroactive Hashable {
    public var opposite: Axis.Set {
        switch self {
        case .horizontal:
            return .vertical
        case .vertical:
            return .horizontal
        default:
            fatalError("use only .horizontal or .vertical")
        }
    }

    public var stringValue: String {
        switch self {
        case .horizontal:
            return "horizontal"
        case .vertical:
            return "vertical"
        default:
            fatalError("use only .horizontal or .vertical")
        }
    }

    public init(stringValue: String) {
        switch stringValue {
        case "horizontal":
            self = .horizontal
        case "vertical":
            self = .vertical
        default:
            fatalError("use only .horizontal or .vertical")
        }
    }
}

#Preview("Axis Extension Demo") {
    VStack(spacing: 20) {
        VStack {
            Text("Horizontal Axis")
                .font(.headline)
            Text("String Value: \(Axis.Set.horizontal.stringValue)")
            Text("Opposite: \(Axis.Set.horizontal.opposite.stringValue)")
        }
        .padding()
        .background(Color.blue.opacity(0.1))
        .cornerRadius(8)
        
        VStack {
            Text("Vertical Axis")
                .font(.headline)
            Text("String Value: \(Axis.Set.vertical.stringValue)")
            Text("Opposite: \(Axis.Set.vertical.opposite.stringValue)")
        }
        .padding()
        .background(Color.green.opacity(0.1))
        .cornerRadius(8)
        
        VStack {
            Text("String Initialization")
                .font(.headline)
            Text("From 'horizontal': \(Axis.Set(stringValue: "horizontal").stringValue)")
            Text("From 'vertical': \(Axis.Set(stringValue: "vertical").stringValue)")
        }
        .padding()
        .background(Color.orange.opacity(0.1))
        .cornerRadius(8)
    }
    .padding()
}

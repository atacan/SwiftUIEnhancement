import SwiftUI

extension Axis.Set {
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

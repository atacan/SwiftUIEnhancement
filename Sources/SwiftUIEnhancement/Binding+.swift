import SwiftUI

public func ?? <T>(lhs: Binding<T?>, rhs: T) -> Binding<T> {
    Binding(
        get: { lhs.wrappedValue ?? rhs },
        set: { lhs.wrappedValue = $0 }
    )
}

public func ?? <T>(lhs: Binding<T>?, rhs: T) -> Binding<T> {
    Binding(
        get: { lhs?.wrappedValue ?? rhs },
        set: { lhs?.wrappedValue = $0 }
    )
}

public func bindOptional<T>(_ lhs: Binding<T?>, _ rhs: T) -> Binding<T> {
    Binding(
        get: { lhs.wrappedValue ?? rhs },
        set: { lhs.wrappedValue = $0 }
    )
}

public func bindOptional<T>(_ lhs: Binding<T>?, _ rhs: T) -> Binding<T> {
    Binding(
        get: { lhs?.wrappedValue ?? rhs },
        set: { lhs?.wrappedValue = $0 }
    )
}

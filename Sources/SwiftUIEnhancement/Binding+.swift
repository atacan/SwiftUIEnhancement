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

public extension Binding {
    
    static func convert<TInt, TFloat>(_ intBinding: Binding<TInt>) -> Binding<TFloat>
    where TInt:   BinaryInteger,
          TFloat: BinaryFloatingPoint{
              
              Binding<TFloat> (
                get: { TFloat(intBinding.wrappedValue) },
                set: { intBinding.wrappedValue = TInt($0) }
              )
          }
    
    static func convert<TFloat, TInt>(_ floatBinding: Binding<TFloat>) -> Binding<TInt>
    where TFloat: BinaryFloatingPoint,
          TInt:   BinaryInteger {
              
              Binding<TInt> (
                get: { TInt(floatBinding.wrappedValue) },
                set: { floatBinding.wrappedValue = TFloat($0) }
              )
          }
}

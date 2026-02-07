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

#Preview("Binding Extensions Demo") {
    struct BindingDemo: View {
        @State private var optionalString: String? = "Hello"
        @State private var defaultValue = "Default"
        @State private var intValue: Int = 42
        @State private var floatValue: Double = 3.14
        
        var body: some View {
            VStack(spacing: 20) {
                VStack {
                    Text("Nil Coalescing Operator")
                        .font(.headline)
                    TextField("Optional Text", text: $optionalString ?? defaultValue)
                        .textFieldStyle(.roundedBorder)
                    Text("Current value: \(optionalString ?? "nil")")
                    Button("Set to nil") { optionalString = nil }
                    Button("Set to value") { optionalString = "Hello World" }
                }
                .padding()
                .background(Color.blue.opacity(0.1))
                .cornerRadius(8)
                
                VStack {
                    Text("Type Conversion")
                        .font(.headline)
                    HStack {
                        Text("Int: \(intValue)")
                        Stepper("", value: $intValue, in: 0...100)
                    }
                    HStack {
                        Text("Float: \(floatValue, specifier: "%.2f")")
                        Slider(value: Binding<Double>.convert($intValue), in: 0...100)
                    }
                }
                .padding()
                .background(Color.green.opacity(0.1))
                .cornerRadius(8)
                
                VStack {
                    Text("bindOptional Function")
                        .font(.headline)
                    TextField("Using bindOptional", text: bindOptional($optionalString, defaultValue))
                        .textFieldStyle(.roundedBorder)
                }
                .padding()
                .background(Color.orange.opacity(0.1))
                .cornerRadius(8)
            }
            .padding()
        }
    }
    
    return BindingDemo()
}

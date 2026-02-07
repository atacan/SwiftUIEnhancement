import SwiftUI

extension AnyTransition {
    public static var slideFromBottom: AnyTransition {
        AnyTransition.asymmetric(
            insertion: .move(edge: .bottom),
            removal: .move(edge: .top)
        )

    }

    public static var slideFromTop: AnyTransition {
        AnyTransition.asymmetric(
            insertion: .move(edge: .top),
            removal: .move(edge: .bottom)
        )

    }

    public static var slideFromTrailing: AnyTransition {
        AnyTransition.asymmetric(
            insertion: .move(edge: .trailing),
            removal: .move(edge: .leading)
        )

    }

    public static var slideFromLeading: AnyTransition {
        AnyTransition.asymmetric(
            insertion: .move(edge: .leading),
            removal: .move(edge: .trailing)
        )

    }
}

#Preview("Custom Transitions") {
    struct TransitionDemo: View {
        @State private var showView = false
        @State private var selectedTransition = 0
        
        let transitions: [(String, AnyTransition)] = [
            ("Slide From Bottom", .slideFromBottom),
            ("Slide From Top", .slideFromTop),
            ("Slide From Leading", .slideFromLeading),
            ("Slide From Trailing", .slideFromTrailing),
            ("Opacity", .opacity),
            ("Scale", .scale),
            ("Slide + Opacity", .slideFromBottom.combined(with: .opacity))
        ]
        
        var body: some View {
            VStack(spacing: 20) {
                Text("Custom Transitions Demo")
                    .font(.headline)
                
                Picker("Transition", selection: $selectedTransition) {
                    ForEach(0..<transitions.count, id: \.self) { index in
                        Text(transitions[index].0).tag(index)
                    }
                }
                #if os(iOS)
                .pickerStyle(.wheel)
                #else
                .pickerStyle(.menu)
                #endif
                .frame(height: 100)
                
                Button(showView ? "Hide View" : "Show View") {
                    withAnimation(.easeInOut(duration: 0.8)) {
                        showView.toggle()
                    }
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
                
                ZStack {
                    Rectangle()
                        .fill(Color.gray.opacity(0.1))
                        .frame(height: 200)
                        .overlay(
                            Text("Animation Area")
                                .foregroundColor(.gray)
                        )
                    
                    if showView {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.blue.opacity(0.8))
                            .frame(width: 150, height: 100)
                            .overlay(
                                VStack {
                                    Image(systemName: "star.fill")
                                        .font(.system(size: 30))
                                        .foregroundColor(.white)
                                    Text("Animated View")
                                        .foregroundColor(.white)
                                        .fontWeight(.semibold)
                                }
                            )
                            .transition(transitions[selectedTransition].1)
                    }
                }
                .cornerRadius(12)
                
                Text("Current: \(transitions[selectedTransition].0)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding()
        }
    }
    
    return TransitionDemo()
}

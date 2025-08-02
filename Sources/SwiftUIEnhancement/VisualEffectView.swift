#if os(macOS)
import SwiftUI

/// Bridge AppKit's NSVisualEffectView into SwiftUI
public struct VisualEffectView: NSViewRepresentable {
    var material: NSVisualEffectView.Material
    var blendingMode: NSVisualEffectView.BlendingMode
    var state: NSVisualEffectView.State
    var emphasized: Bool

    public init(
        material: NSVisualEffectView.Material,
        blendingMode: NSVisualEffectView.BlendingMode,
        state: NSVisualEffectView.State,
        emphasized: Bool
    ) {
        self.material = material
        self.blendingMode = blendingMode
        self.state = state
        self.emphasized = emphasized
    }

    public func makeNSView(context: Context) -> NSVisualEffectView {
        context.coordinator.visualEffectView
    }

    public func updateNSView(_ view: NSVisualEffectView, context: Context) {
        context.coordinator.update(
            material: material,
            blendingMode: blendingMode,
            state: state,
            emphasized: emphasized
        )
    }

    public func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    public class Coordinator {
        let visualEffectView = NSVisualEffectView()

        init() {
            visualEffectView.blendingMode = .withinWindow
        }

        func update(
            material: NSVisualEffectView.Material,
            blendingMode: NSVisualEffectView.BlendingMode,
            state: NSVisualEffectView.State,
            emphasized: Bool
        ) {
            visualEffectView.material = material
        }
    }
}
#endif

#if os(iOS)
import SwiftUI
import UIKit

/// Bridge UIKit's UIVisualEffectView into SwiftUI for iOS
public struct VisualEffectView: UIViewRepresentable {
    var effect: UIVisualEffect?
    
    public init(effect: UIVisualEffect?) {
        self.effect = effect
    }
    
    public func makeUIView(context: Context) -> UIVisualEffectView {
        UIVisualEffectView()
    }
    
    public func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = effect
    }
}
#endif

#Preview("Visual Effect View") {
    VStack(spacing: 20) {
        Text("Visual Effect View Demo")
            .font(.largeTitle)
            .fontWeight(.bold)
        
        ZStack {
            // Background image/content
            LinearGradient(
                colors: [.blue, .purple, .pink],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .frame(height: 200)
            
            VStack(spacing: 15) {
                #if os(macOS)
                HStack(spacing: 15) {
                    VisualEffectView(
                        material: .hudWindow,
                        blendingMode: .behindWindow,
                        state: .active,
                        emphasized: false
                    )
                    .frame(width: 120, height: 80)
                    .overlay(
                        VStack {
                            Image(systemName: "star.fill")
                                .foregroundColor(.white)
                            Text("HUD Window")
                                .foregroundColor(.white)
                                .font(.caption)
                        }
                    )
                    .cornerRadius(12)
                    
                    VisualEffectView(
                        material: .sidebar,
                        blendingMode: .behindWindow,
                        state: .active,
                        emphasized: true
                    )
                    .frame(width: 120, height: 80)
                    .overlay(
                        VStack {
                            Image(systemName: "sidebar.left")
                                .foregroundColor(.primary)
                            Text("Sidebar")
                                .foregroundColor(.primary)
                                .font(.caption)
                        }
                    )
                    .cornerRadius(12)
                }
                
                HStack(spacing: 15) {
                    VisualEffectView(
                        material: .menu,
                        blendingMode: .behindWindow,
                        state: .active,
                        emphasized: false
                    )
                    .frame(width: 120, height: 80)
                    .overlay(
                        VStack {
                            Image(systemName: "list.bullet")
                                .foregroundColor(.primary)
                            Text("Menu")
                                .foregroundColor(.primary)
                                .font(.caption)
                        }
                    )
                    .cornerRadius(12)
                    
                    VisualEffectView(
                        material: .popover,
                        blendingMode: .behindWindow,
                        state: .active,
                        emphasized: false
                    )
                    .frame(width: 120, height: 80)
                    .overlay(
                        VStack {
                            Image(systemName: "bubble.left")
                                .foregroundColor(.primary)
                            Text("Popover")
                                .foregroundColor(.primary)
                                .font(.caption)
                        }
                    )
                    .cornerRadius(12)
                }
                #endif
                
                #if os(iOS)
                VStack(spacing: 15) {
                    VisualEffectView(effect: UIBlurEffect(style: .systemMaterial))
                        .frame(height: 60)
                        .overlay(
                            HStack {
                                Image(systemName: "star.fill")
                                    .foregroundColor(.primary)
                                Text("System Material")
                                    .foregroundColor(.primary)
                                Spacer()
                            }
                            .padding()
                        )
                        .cornerRadius(12)
                    
                    VisualEffectView(effect: UIBlurEffect(style: .systemThinMaterial))
                        .frame(height: 60)
                        .overlay(
                            HStack {
                                Image(systemName: "circle.fill")
                                    .foregroundColor(.primary)
                                Text("Thin Material")
                                    .foregroundColor(.primary)
                                Spacer()
                            }
                            .padding()
                        )
                        .cornerRadius(12)
                    
                    VisualEffectView(effect: UIBlurEffect(style: .systemThickMaterial))
                        .frame(height: 60)
                        .overlay(
                            HStack {
                                Image(systemName: "square.fill")
                                    .foregroundColor(.primary)
                                Text("Thick Material")
                                    .foregroundColor(.primary)
                                Spacer()
                            }
                            .padding()
                        )
                        .cornerRadius(12)
                }
                #endif
            }
            .padding()
        }
        .cornerRadius(16)
        
        Text("Visual effects provide translucent backgrounds that blend with content behind them")
            .font(.caption)
            .foregroundColor(.secondary)
            .multilineTextAlignment(.center)
    }
    .padding()
}

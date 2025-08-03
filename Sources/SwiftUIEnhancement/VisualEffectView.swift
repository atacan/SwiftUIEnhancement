import SwiftUI

#if os(macOS)
import AppKit
#elseif os(iOS)
import UIKit
#endif

public struct VisualEffectView {
    public enum Material {
        case appearanceBased
        case light
        case dark
        case titlebar
        case selection
        case menu
        case popover
        case sidebar
        case mediumLight
        case ultraDark
        case headerView
        case sheet
        case windowBackground
        case hudWindow
        case fullScreenUI
        case toolTip
        case contentBackground
        case underWindowBackground
        case underPageBackground
    }

    public enum BlendingMode {
        case behindWindow
        case withinWindow
    }

    public enum State {
        case followsWindowActiveState
        case active
        case inactive
    }

    public let material: Material
    public let blendingMode: BlendingMode
    public let state: State
    public let emphasized: Bool

    public init(
        material: Material,
        blendingMode: BlendingMode,
        state: State,
        emphasized: Bool
    ) {
        self.material = material
        self.blendingMode = blendingMode
        self.state = state
        self.emphasized = emphasized
    }
}

#if os(macOS)
extension VisualEffectView.Material {
    var nsMaterial: NSVisualEffectView.Material {
        switch self {
        case .appearanceBased: return .appearanceBased
        case .light: return .light
        case .dark: return .dark
        case .titlebar: return .titlebar
        case .selection: return .selection
        case .menu: return .menu
        case .popover: return .popover
        case .sidebar: return .sidebar
        case .mediumLight: return .mediumLight
        case .ultraDark: return .ultraDark
        case .headerView: return .headerView
        case .sheet: return .sheet
        case .windowBackground: return .windowBackground
        case .hudWindow: return .hudWindow
        case .fullScreenUI: return .fullScreenUI
        case .toolTip: return .toolTip
        case .contentBackground: return .contentBackground
        case .underWindowBackground: return .underWindowBackground
        case .underPageBackground: return .underPageBackground
        }
    }
}

extension VisualEffectView.BlendingMode {
    var nsBlendingMode: NSVisualEffectView.BlendingMode {
        switch self {
        case .behindWindow: return .behindWindow
        case .withinWindow: return .withinWindow
        }
    }
}

extension VisualEffectView.State {
    var nsState: NSVisualEffectView.State {
        switch self {
        case .followsWindowActiveState: return .followsWindowActiveState
        case .active: return .active
        case .inactive: return .inactive
        }
    }
}

extension VisualEffectView: NSViewRepresentable {
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

        init() {}

        func update(
            material: VisualEffectView.Material,
            blendingMode: VisualEffectView.BlendingMode,
            state: VisualEffectView.State,
            emphasized: Bool
        ) {
            visualEffectView.material = material.nsMaterial
            visualEffectView.blendingMode = blendingMode.nsBlendingMode
            visualEffectView.state = state.nsState
            visualEffectView.isEmphasized = emphasized
        }
    }
}
#endif

#if os(iOS)
extension VisualEffectView: UIViewRepresentable {
    public func makeUIView(context: Context) -> UIVisualEffectView {
        context.coordinator.visualEffectView
    }

    public func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
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
        let visualEffectView = UIVisualEffectView()

        init() {}

        func update(
            material: VisualEffectView.Material,
            blendingMode: VisualEffectView.BlendingMode,
            state: VisualEffectView.State,
            emphasized: Bool
        ) {
            visualEffectView.effect = effect(for: material, state: state)
        }

        private func effect(for material: VisualEffectView.Material, state: VisualEffectView.State) -> UIVisualEffect? {
            if state == .inactive {
                return nil
            }
            let style = blurStyle(for: material)
            return UIBlurEffect(style: style)
        }

        private func blurStyle(for material: VisualEffectView.Material) -> UIBlurEffect.Style {
            switch material {
            case .appearanceBased: return .regular
            case .light: return .light
            case .dark: return .dark
            case .titlebar: return .systemChromeMaterial
            case .selection: return .prominent
            case .menu: return .systemThinMaterial
            case .popover: return .systemThinMaterial
            case .sidebar: return .systemMaterial
            case .mediumLight: return .systemMaterialLight
            case .ultraDark: return .systemMaterialDark
            case .headerView: return .systemThickMaterial
            case .sheet: return .systemUltraThinMaterial
            case .windowBackground: return .systemMaterial
            case .hudWindow: return .systemChromeMaterial
            case .fullScreenUI: return .systemUltraThinMaterial
            case .toolTip: return .systemUltraThinMaterial
            case .contentBackground: return .systemMaterial
            case .underWindowBackground: return .extraLight
            case .underPageBackground: return .light
            }
        }
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
                ScrollView(.horizontal) {
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
                                Text("HUD Window")
                            }
                                .foregroundColor(.primary)
                                .font(.caption)
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
                                Text("Sidebar")
                            }
                                .foregroundColor(.primary)
                                .font(.caption)
                        )
                        .cornerRadius(12)
                        
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
                                Text("Menu")
                            }
                                .foregroundColor(.primary)
                                .font(.caption)
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
                                Text("Popover")
                            }
                                .foregroundColor(.primary)
                                .font(.caption)
                        )
                        .cornerRadius(12)
                    }
                }
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

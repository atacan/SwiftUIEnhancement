#if os(macOS)
import SwiftUI

public struct PopupButton<Key: Nameable>: NSViewRepresentable {
    @Binding var selectedKey: Key
    let keys: [Key]
    
    public init(selectedKey: Binding<Key>, keys: [Key]) {
        self._selectedKey = selectedKey
        self.keys = keys
    }

    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    public func makeNSView(context: Context) -> NSPopUpButton {
        let button = NSPopUpButton()
        button.target = context.coordinator
        button.action = #selector(Coordinator.itemSelected(_:))
        return button
    }

    public func updateNSView(_ nsView: NSPopUpButton, context: Context) {
        nsView.removeAllItems()

        for key in keys {
            nsView.addItem(withTitle: key.displayName)
            if let lastItem = nsView.lastItem {
                lastItem.representedObject = key
            }
        }

        if let index = keys.firstIndex(where: { $0.id == selectedKey.id }) {
            nsView.selectItem(at: index)
        } else {
            nsView.select(nil)
        }
    }

    public class Coordinator: NSObject {
        var parent: PopupButton

        init(_ parent: PopupButton) {
            self.parent = parent
        }

        @objc
        func itemSelected(_ sender: NSPopUpButton) {
            if let key = sender.selectedItem?.representedObject as? Key {
                parent.selectedKey = key
            }
        }
    }
}
#endif

#if os(iOS)
import SwiftUI
import UIKit

public struct PopupButton<Key: Nameable>: UIViewRepresentable {
    @Binding var selectedKey: Key
    let keys: [Key]
    
    public init(selectedKey: Binding<Key>, keys: [Key]) {
        self._selectedKey = selectedKey
        self.keys = keys
    }

    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    public func makeUIView(context: Context) -> UIButton {
        let button = UIButton(type: .system)
        button.showsMenuAsPrimaryAction = true
        return button
    }

    public func updateUIView(_ uiView: UIButton, context: Context) {
        var actions: [UIAction] = []
        
        for key in keys {
            let action = UIAction(title: key.displayName) { _ in
                selectedKey = key
            }
            actions.append(action)
        }
        
        uiView.menu = UIMenu(children: actions)
        uiView.setTitle(selectedKey.displayName, for: .normal)
    }

    public class Coordinator: NSObject {
        var parent: PopupButton

        init(_ parent: PopupButton) {
            self.parent = parent
        }
    }
}
#endif

#Preview("Popup Button") {
    struct SampleOption: Nameable {
        let id = UUID()
        let displayName: String
    }
    
    struct PopupButtonDemo: View {
        @State private var selectedOption = SampleOption(displayName: "Option 1")
        
        let options = [
            SampleOption(displayName: "Option 1"),
            SampleOption(displayName: "Option 2"),
            SampleOption(displayName: "Option 3"),
            SampleOption(displayName: "Very Long Option Name That Tests Wrapping"),
            SampleOption(displayName: "🎨 Option with Emoji"),
            SampleOption(displayName: "Final Option")
        ]
        
        var body: some View {
            VStack(spacing: 30) {
                Text("Popup Button Demo")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                VStack(spacing: 15) {
                    Text("Cross-platform PopupButton")
                        .font(.headline)
                    
                    PopupButton(selectedKey: $selectedOption, keys: options)
                        .frame(width: 200)
                        #if os(macOS)
                        .controlSize(.large)
                        #endif
                }
                .padding()
                .background(Color.blue.opacity(0.1))
                .cornerRadius(12)
                
                VStack(spacing: 10) {
                    Text("Selected Option:")
                        .font(.headline)
                    
                    Text(selectedOption.displayName)
                        .font(.title2)
                        .foregroundColor(.blue)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                }
                
                VStack(spacing: 10) {
                    Text("Available Options:")
                        .font(.headline)
                    
                    LazyVStack(spacing: 8) {
                        ForEach(options) { option in
                            HStack {
                                Image(systemName: option.id == selectedOption.id ? "checkmark.circle.fill" : "circle")
                                    .foregroundColor(option.id == selectedOption.id ? .green : .gray)
                                Text(option.displayName)
                                    .fontWeight(option.id == selectedOption.id ? .semibold : .regular)
                                Spacer()
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(12)
                }
                
                #if os(macOS)
                Text("On macOS: Uses NSPopUpButton")
                    .font(.caption)
                    .foregroundColor(.secondary)
                #endif
                
                #if os(iOS)
                Text("On iOS: Uses UIButton with UIMenu")
                    .font(.caption)
                    .foregroundColor(.secondary)
                #endif
            }
            .padding()
        }
    }
    
    return PopupButtonDemo()
}

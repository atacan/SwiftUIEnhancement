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

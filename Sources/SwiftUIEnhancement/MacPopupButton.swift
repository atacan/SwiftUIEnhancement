import SwiftUI

struct MacPopupButton<Key: Nameable>: NSViewRepresentable {
    @Binding var selectedKey: Key
    let keys: [Key]

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeNSView(context: Context) -> NSPopUpButton {
        let button = NSPopUpButton()
        button.target = context.coordinator
        button.action = #selector(Coordinator.itemSelected(_:))
        return button
    }

    func updateNSView(_ nsView: NSPopUpButton, context: Context) {
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

    class Coordinator: NSObject {
        var parent: MacPopupButton

        init(_ parent: MacPopupButton) {
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

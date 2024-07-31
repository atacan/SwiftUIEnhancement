import SwiftUI

public struct MenuPicker<Item: Nameable>: View {
    @Binding var selection: Item
    let allValues: [Item]

    public init(selection: Binding<Item>, allValues: [Item]) {
        self._selection = selection
        self.allValues = allValues
    }

    public var body: some View {
        Menu {
            ForEach(allValues) { item in
                Button(item.displayName, action: { selection = item })
            }
        } label: {
            Text(selection.displayName)
        }
    }
}

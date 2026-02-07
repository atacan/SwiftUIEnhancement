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

#Preview("Menu Picker") {
    struct SampleItem: Nameable {
        let id = UUID()
        let displayName: String
    }
    
    struct MenuPickerDemo: View {
        @State private var selectedItem = SampleItem(displayName: "First Item")
        
        let items = [
            SampleItem(displayName: "First Item"),
            SampleItem(displayName: "Second Item"),
            SampleItem(displayName: "Third Item"),
            SampleItem(displayName: "Fourth Item"),
            SampleItem(displayName: "Fifth Item")
        ]
        
        var body: some View {
            VStack(spacing: 20) {
                Text("Menu Picker Demo")
                    .font(.headline)
                
                MenuPicker(selection: $selectedItem, allValues: items)
                    .padding()
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(8)
                
                Text("Selected: \(selectedItem.displayName)")
                    .foregroundColor(.secondary)
                
                VStack {
                    Text("All Available Items:")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    
                    ForEach(items) { item in
                        HStack {
                            Image(systemName: item.id == selectedItem.id ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(item.id == selectedItem.id ? .green : .gray)
                            Text(item.displayName)
                            Spacer()
                        }
                        .padding(.horizontal)
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
            }
            .padding()
        }
    }
    
    return MenuPickerDemo()
}

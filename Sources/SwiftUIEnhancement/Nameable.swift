import SwiftUI
import Foundation

public protocol Nameable: Identifiable {
    var displayName: String { get }
}

struct NameableProtocolDemo_Previews: PreviewProvider {
    struct ExampleItem: Nameable {
        let id = UUID()
        let displayName: String
        let category: String
        
        init(_ name: String, category: String = "General") {
            self.displayName = name
            self.category = category
        }
    }
    
    struct NameableDemo: View {
        let items = [
            ExampleItem("Home", category: "Navigation"),
            ExampleItem("Settings", category: "Configuration"),
            ExampleItem("Profile", category: "User"),
            ExampleItem("Dashboard", category: "Analytics"),
            ExampleItem("Reports", category: "Analytics"),
            ExampleItem("Help", category: "Support"),
            ExampleItem("About", category: "Information")
        ]
        
        var body: some View {
            VStack(spacing: 20) {
                Text("Nameable Protocol")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("A protocol that provides consistent naming for UI components")
                    .font(.headline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Protocol Requirements:")
                        .font(.headline)
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text("• Identifiable: Must have a unique `id`")
                        Text("• displayName: String for user-facing display")
                    }
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                }
                .padding()
                .background(Color.blue.opacity(0.1))
                .cornerRadius(12)
                
                VStack {
                    Text("Example Items")
                        .font(.headline)
                    
                    LazyVStack(spacing: 8) {
                        ForEach(items) { item in
                            HStack {
                                Image(systemName: "circle.fill")
                                    .foregroundColor(.blue)
                                    .font(.caption)
                                
                                VStack(alignment: .leading) {
                                    Text(item.displayName)
                                        .fontWeight(.semibold)
                                    Text(item.category)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                
                                Spacer()
                                
                                Text("ID: \(item.id.uuidString.prefix(8))...")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 8)
                            .background(Color.gray.opacity(0.05))
                            .cornerRadius(8)
                        }
                    }
                }
                .padding()
                .background(Color.green.opacity(0.1))
                .cornerRadius(12)
                
                VStack {
                    Text("Used By:")
                        .font(.headline)
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text("• MenuPicker<Item: Nameable>")
                        Text("• PopupButton<Key: Nameable>")
                        Text("• Any component needing consistent naming")
                    }
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                }
                .padding()
                .background(Color.orange.opacity(0.1))
                .cornerRadius(12)
            }
            .padding()
        }
    }
    
    static var previews: some View {
        NameableDemo()
    }
}

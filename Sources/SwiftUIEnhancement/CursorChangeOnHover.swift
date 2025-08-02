#if canImport(AppKit)
import AppKit
import SwiftUI

extension View {
    public func cursor(_ cursor: NSCursor) -> some View {
        if #available(macOS 13.0, *) {
            return self.onContinuousHover { phase in
                switch phase {
                case .active(_):
                    guard NSCursor.current != cursor else { return }
                    cursor.push()
                case .ended:
                    NSCursor.pop()
                }
            }
        } else {
            return self.onHover { inside in
                if inside {
                    cursor.push()
                } else {
                    NSCursor.pop()
                }
            }
        }
    }
}

#Preview("Cursor Change On Hover") {
    VStack(spacing: 20) {
        Text("Hover over these elements to see cursor changes")
            .font(.headline)
            .padding()
        
        HStack(spacing: 20) {
            Rectangle()
                .fill(Color.blue)
                .frame(width: 100, height: 100)
                .cursor(.pointingHand)
                .overlay(Text("Hand").foregroundColor(.white))
            
            Rectangle()
                .fill(Color.green)
                .frame(width: 100, height: 100)
                .cursor(.crosshair)
                .overlay(Text("Crosshair").foregroundColor(.white))
            
            Rectangle()
                .fill(Color.red)
                .frame(width: 100, height: 100)
                .cursor(.resizeUpDown)
                .overlay(Text("Resize").foregroundColor(.white))
        }
        
        HStack(spacing: 20) {
            Button("Click Me") { }
                .padding()
                .cursor(.pointingHand)
            
            Text("I-Beam Text")
                .padding()
                .background(Color.gray.opacity(0.2))
                .cursor(.iBeam)
            
            Image(systemName: "magnifyingglass")
                .font(.system(size: 30))
                .padding()
                .cursor(.crosshair)
        }
        
        Text("macOS only - no effect on other platforms")
            .font(.caption)
            .foregroundColor(.secondary)
    }
    .padding()
}
#endif
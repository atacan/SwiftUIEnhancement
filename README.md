# UsefulThingsSwiftUI

A collection of SwiftUI components, view modifiers, and utilities for building macOS and iOS apps. Fills in gaps that SwiftUI doesn't cover out of the box — native popup buttons, async modal presentation, floating panels, text editors that don't update on every keystroke, and more.

## Requirements

- iOS 14+ / macOS 13+
- Swift 5.9+

## Installation

Add the package to your project via Swift Package Manager:

```swift
dependencies: [
    .package(url: "https://github.com/atacan/UsefulThingsSwiftUI.git", from: "1.0.0")
]
```

Or in Xcode: **File > Add Package Dependencies** and paste the repository URL.

## Components

### Async Modal Presenters

Present sheets, alerts, popovers, and dialogs using `async`/`await` instead of managing `@State` booleans. Each presenter type conforms to a shared `ModalPresenter` protocol and is driven by `AsyncUIRunner`.

```swift
let sheetPresenter = AnySheetPresenter()

var body: some View {
    Button("Show Sheet") {
        Task {
            let result = try await AsyncUIRunner(presenter: sheetPresenter)
                .runAny { handle in
                    VStack {
                        Text("Pick something")
                        Button("Done") { handle.finish("picked") }
                        Button("Cancel") { handle.cancel() }
                    }
                }
            print(result) // "picked"
        }
    }
    .sheetPresenter(sheetPresenter)
}
```

Available presenters:

| Presenter | Platform | Description |
|---|---|---|
| `SheetPresenter` | iOS, macOS | Modal sheet |
| `AlertPresenter` | iOS 15+, macOS 12+ | Alert dialog |
| `DialogPresenter` | iOS 15+, macOS 12+ | Confirmation dialog |
| `PopoverPresenter` | iOS, macOS | Popover (macOS supports mouse-cursor anchoring) |
| `FullScreenCoverPresenter` | iOS | Full screen cover |
| `MacWindowPresenter` | macOS | Opens content in a new `NSWindow` |

Each has an `Any*` typealias (e.g. `AnySheetPresenter`) for convenience with `AnyView`.

---

### PopupButton

A native dropdown menu — wraps `NSPopUpButton` on macOS and `UIButton` with `UIMenu` on iOS. Works with any type conforming to the `Nameable` protocol.

```swift
struct Language: Nameable {
    let id = UUID()
    let displayName: String
}

@State var selected = Language(displayName: "Swift")

PopupButton(
    selectedKey: $selected,
    keys: [
        Language(displayName: "Swift"),
        Language(displayName: "Rust"),
        Language(displayName: "Go"),
    ]
)
```

---

### PatientTextField / PatientTextEditor

Text inputs that only update their binding when editing ends, not on every keystroke. Useful when the binding triggers expensive work.

```swift
@State var query = ""

// Cross-platform
PatientTextField("Search...", text: $query)

// macOS only — full NSTextView with configurable spell checking,
// autocomplete, link detection, etc.
PatientTextEditor(text: $query)

// macOS only — rich text via NSAttributedString
PatientAttributedTextEditor(text: $attributedText)
```

---

### FloatingPanel (macOS)

A floating `NSPanel` that stays on top, has no visible titlebar, and dismisses when it loses focus.

```swift
@State var showPanel = false

Button("Show Panel") { showPanel = true }
    .floatingPanel(isPresented: $showPanel) {
        Text("I'm floating")
            .padding()
    }
```

---

### OpenInWindow (macOS)

Open any SwiftUI view in a new `NSWindow`.

```swift
Button("Detach") {
    MyDetailView()
        .openInNewWindow(
            title: "Detail",
            rect: CGRect(x: 0, y: 0, width: 600, height: 400),
            makeKey: true
        )
}
```

---

### VisualEffectView

Translucent blur backgrounds — wraps `NSVisualEffectView` on macOS and `UIVisualEffectView` on iOS with a unified API.

```swift
VisualEffectView(
    material: .sidebar,
    blendingMode: .behindWindow,
    state: .active,
    emphasized: true
)
```

---

### Dynamic Layout

Components that switch between horizontal and vertical layouts based on an `Axis.Set` value:

```swift
@State var axis: Axis.Set = .horizontal

// Switches between HStack / VStack
DynamicStack(axis: axis, spacing: 8) {
    Text("A")
    Text("B")
}

// Switches between LazyHGrid / LazyVGrid
DynamicLazyGrid(axis: axis, columns: [GridItem(.flexible())]) {
    ForEach(items) { item in
        ItemView(item)
    }
}

// Switches between horizontal / vertical ScrollView
DynamicScrollView(axis: axis) {
    // ...
}
```

---

### View Modifiers

**Corner radius with border**
```swift
RoundedRectangle(cornerRadius: 0)
    .cornerRadiusWithBorder(radius: 12, borderLineWidth: 2, borderColor: .blue)
```

**Glow and shadow effects**
```swift
Circle().glow(color: .blue, radius: 20)
Text("Neon").multicolorGlow()
Rectangle().innerShadow(using: RoundedRectangle(cornerRadius: 8), color: .black, width: 4, blur: 4)
```

**Rotation with corrected frame**
```swift
Text("Sideways").rotated(.degrees(-90))
```

**Cursor on hover (macOS)**
```swift
Button("Click me") { }
    .cursor(.pointingHand)
```

**Click detection (macOS)**
```swift
Text("Click target")
    .onClick(
        onSingleClick: { /* ... */ },
        onDoubleClick: { /* ... */ },
        onTripleClick: { /* ... */ }
    )
```

---

### Transitions

Pre-built asymmetric slide transitions:

```swift
MyView()
    .transition(.slideFromBottom)
    // also: .slideFromTop, .slideFromLeading, .slideFromTrailing
```

---

### SplashingButton

An animated button with a splash effect. Requires macOS 14+ / iOS 17+.

```swift
SplashingButton(imageSystemName: "heart.fill") {
    // action
}
```

---

### Color Utilities

```swift
// Hex colors
let color = Color.hex(0xFF5733)

// Brightness
Color.blue.brighter(by: 0.2)
Color.blue.darker(by: 0.3)

// Codable wrapper with contrast calculation
let (bg, fg) = CodableCGColor.randomBGFG()

// Dynamic colors (iOS)
Color(dynamicProvider: { traits in
    traits.userInterfaceStyle == .dark ? .white : .black
})
```

---

### Binding Utilities

```swift
// Nil-coalescing for optional bindings
TextField("Name", text: $optionalName ?? "default")

// Numeric type conversion
Slider(value: Binding<Double>.convert($intValue), in: 0...100)
```

---

### Other Utilities

| Component | Description |
|---|---|
| `SizePreferenceKey` | Track a view's size via preference keys |
| `MenuPicker` | Dropdown picker for `Nameable` items |
| `TextFile` | `FileDocument` for text-based file import/export |
| `Nameable` | Protocol requiring `id` and `displayName` |
| `NSPopoverHolderView` | Direct `NSPopover` wrapper (macOS) |
| `imageFrom(filePath:)` | Load a SwiftUI `Image` from a file path |

## Platform Availability

| Component | macOS | iOS |
|---|---|---|
| Async Modal Presenters | 12+ | 15+ |
| PopupButton | 13+ | 14+ |
| PatientTextField | 13+ | 14+ |
| PatientTextEditor | 13+ | — |
| FloatingPanel | 13+ | — |
| OpenInWindow | 13+ | — |
| VisualEffectView | 13+ | 14+ |
| Dynamic Layout | 13+ | 14+ |
| Click Detection | 13+ | — |
| Cursor on Hover | 13+ | — |
| SplashingButton | 14+ | 17+ |
| All other utilities | 13+ | 14+ |

## License

See [LICENSE](LICENSE) for details.

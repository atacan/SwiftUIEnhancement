import SwiftUI

extension View {
    /// Adds a double click handler this view (macOS only)
    ///
    /// Example
    /// ```
    /// Text("Hello")
    ///     .onDoubleClick { print("Double click detected") }
    /// ```
    /// - Parameters:
    ///   - handler: Block invoked when a double click is detected
    public func onDoubleClick(handler: @escaping () -> Void) -> some View {
        modifier(DoubleClickHandler(handler: handler))
    }

    /// Adds a click handler this view (macOS only)
    ///
    /// Example
    /// ```
    /// Text("Hello")
    ///     .onClick(
    ///         onSingleClick: { print("Single click detected") },
    ///         onDoubleClick: { print("Double click detected") },
    ///         onTripleClick: { print("Triple click detected") }
    ///     )
    /// ```
    /// - Parameters:
    ///   - onSingleClick: Block invoked when a single click is detected
    ///   - onDoubleClick: Block invoked when a double click is detected
    ///   - onTripleClick: Block invoked when a triple click is detected
    public func onClick(
        onSingleClick: @escaping () -> Void,
        onDoubleClick: @escaping () -> Void,
        onTripleClick: @escaping () -> Void
    ) -> some View {
        modifier(
            ClickHandler(
                onSingleClick: onSingleClick,
                onDoubleClick: onDoubleClick,
                onTripleClick: onTripleClick
            )
        )
    }
}

// MARK: - Double Click

struct DoubleClickHandler: ViewModifier {
    let handler: () -> Void
    func body(content: Content) -> some View {
        content.overlay {
            DoubleClickListeningViewRepresentable(handler: handler)
        }
    }
}

struct DoubleClickListeningViewRepresentable: NSViewRepresentable {
    let handler: () -> Void
    func makeNSView(context: Context) -> DoubleClickListeningView {
        DoubleClickListeningView(handler: handler)
    }

    func updateNSView(_ nsView: DoubleClickListeningView, context: Context) {}
}

class DoubleClickListeningView: NSView {
    let handler: () -> Void

    init(handler: @escaping () -> Void) {
        self.handler = handler
        super.init(frame: .zero)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func mouseDown(with event: NSEvent) {
        super.mouseDown(with: event)
        if event.clickCount == 2 {
            handler()
        }
    }
}

// MARK: - Single, Double, Triple Click

struct ClickHandler: ViewModifier {
    let onSingleClick: () -> Void
    let onDoubleClick: () -> Void
    let onTripleClick: () -> Void

    func body(content: Content) -> some View {
        content.overlay {
            ClickListeningViewRepresentable(
                onSingleClick: onSingleClick,
                onDoubleClick: onDoubleClick,
                onTripleClick: onTripleClick
            )
        }
    }
}

struct ClickListeningViewRepresentable: NSViewRepresentable {
    let onSingleClick: () -> Void
    let onDoubleClick: () -> Void
    let onTripleClick: () -> Void

    func makeNSView(context: Context) -> ClickListeningView {
        ClickListeningView(
            onSingleClick: onSingleClick,
            onDoubleClick: onDoubleClick,
            onTripleClick: onTripleClick
        )
    }

    func updateNSView(_ nsView: ClickListeningView, context: Context) {}
}

// class ClickListeningView: NSView {
//     let onSingleClick: () -> Void
//     let onDoubleClick: () -> Void
//     let onTripleClick: () -> Void

//     init(
//         onSingleClick: @escaping () -> Void,
//         onDoubleClick: @escaping () -> Void,
//         onTripleClick: @escaping () -> Void
//     ) {
//         self.onSingleClick = onSingleClick
//         self.onDoubleClick = onDoubleClick
//         self.onTripleClick = onTripleClick
//         super.init(frame: .zero)
//     }

//     @available(*, unavailable)
//     required init?(coder: NSCoder) {
//         fatalError("init(coder:) has not been implemented")
//     }

//     override func mouseDown(with event: NSEvent) {
//         super.mouseDown(with: event)

//         switch event.clickCount {
//         case 3:
//             onTripleClick()
//         case 2:
//             onDoubleClick()
//         case 1:
//             onSingleClick()
//         default:
//             break
//         }
//     }
// }

import Cocoa

class ClickListeningView: NSView {
    private var lastClickTimestamp: TimeInterval?
    private var clickCount: Int = 0

    let onSingleClick: () -> Void
    let onDoubleClick: () -> Void
    let onTripleClick: () -> Void

    init(
        onSingleClick: @escaping () -> Void,
        onDoubleClick: @escaping () -> Void,
        onTripleClick: @escaping () -> Void
    ) {
        self.onSingleClick = onSingleClick
        self.onDoubleClick = onDoubleClick
        self.onTripleClick = onTripleClick
        super.init(frame: .zero)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func mouseDown(with event: NSEvent) {
        super.mouseDown(with: event)

        let doubleClickInterval = NSEvent.doubleClickInterval
        let timestamp = event.timestamp

        if let lastClickTimestamp,
           timestamp - lastClickTimestamp < doubleClickInterval {
            // If the time between clicks is less than the system's double click interval
            clickCount += 1
        } else {
            // If not, reset the click count
            clickCount = 1
        }

        // Update the timestamp for the most recent click
        lastClickTimestamp = timestamp

        switch clickCount {
        case 1:
            // Schedule to perform single click if no more clicks happen
            DispatchQueue.main.asyncAfter(deadline: .now() + doubleClickInterval) { [weak self] in
                guard let strongSelf = self else {
                    return
                }

                // If the clickCount is still 1 after the delay, perform single click
                if strongSelf.clickCount == 1 {
                    strongSelf.onSingleClick()
                    strongSelf.resetClickState()
                }
            }
        case 2:
            // Perform double click immediately and reset state
            onDoubleClick()
            resetClickState()
        case 3:
            // Perform triple click immediately and reset state
            onTripleClick()
            resetClickState()
        default:
            break
        }
    }

    // Helper method to reset click tracking state
    private func resetClickState() {
        lastClickTimestamp = nil
        clickCount = 0
    }
}

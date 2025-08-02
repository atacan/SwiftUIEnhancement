import SwiftUI

public struct PatientTextField: View {
    @Binding var text: String
    @State private var currentText: String
    let placeholder: String

    public init(_ placeholder: String = "", text: Binding<String>) {
        self.placeholder = placeholder
        self._text = text
        self._currentText = State(initialValue: text.wrappedValue)
    }

    public var body: some View {
        TextField(
            placeholder,
            text: $currentText,
            onEditingChanged: { isEditing in
                if !isEditing {
                    text = currentText
                }
            },
            onCommit: {
                text = currentText
            }
        )
        // to update the text field when the text changes from outside
        .onChange(of: text) { newValue in
            if currentText != newValue {
                currentText = newValue
            }
        }
    }
}

#if canImport(AppKit)
import AppKit
public struct PatientTextEditor: NSViewRepresentable {
    @Binding var text: String

    public var isAutomaticDataDetectionEnabled: Bool
    public var isAutomaticLinkDetectionEnabled: Bool
    public var isAutomaticSpellingCorrectionEnabled: Bool
    public var isAutomaticTextCompletionEnabled: Bool
    public var isAutomaticTextReplacementEnabled: Bool
    public var isContinuousSpellCheckingEnabled: Bool
    public var isGrammarCheckingEnabled: Bool

    public init(
        text: Binding<String>,
        isAutomaticDataDetectionEnabled: Bool = true,
        isAutomaticLinkDetectionEnabled: Bool = true,
        isAutomaticSpellingCorrectionEnabled: Bool = true,
        isAutomaticTextCompletionEnabled: Bool = true,
        isAutomaticTextReplacementEnabled: Bool = true,
        isContinuousSpellCheckingEnabled: Bool = true,
        isGrammarCheckingEnabled: Bool = true
    ) {
        self._text = text
        self.isAutomaticDataDetectionEnabled = isAutomaticDataDetectionEnabled
        self.isAutomaticLinkDetectionEnabled = isAutomaticLinkDetectionEnabled
        self.isAutomaticSpellingCorrectionEnabled = isAutomaticSpellingCorrectionEnabled
        self.isAutomaticTextCompletionEnabled = isAutomaticTextCompletionEnabled
        self.isAutomaticTextReplacementEnabled = isAutomaticTextReplacementEnabled
        self.isContinuousSpellCheckingEnabled = isContinuousSpellCheckingEnabled
        self.isGrammarCheckingEnabled = isGrammarCheckingEnabled
    }

    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    public func makeNSView(context: Context) -> NSScrollView {
        let scrollView = NSScrollView()
        let textView = NSTextView()

        scrollView.hasVerticalScroller = true
        scrollView.documentView = textView

        textView.delegate = context.coordinator
        textView.isVerticallyResizable = true
        textView.autoresizingMask = [.width]
        textView.textContainer?.containerSize = CGSize(width: textView.bounds.width, height: CGFloat.infinity)
        textView.textContainer?.widthTracksTextView = true
        textView.font = NSFont.monospacedSystemFont(ofSize: 11, weight: .regular)
        textView.isRichText = false
        textView.usesFontPanel = true

        textView.allowsUndo = true

        textView.isIncrementalSearchingEnabled = true
        textView.usesFindBar = true

        textView.isAutomaticDataDetectionEnabled = self.isAutomaticDataDetectionEnabled
        textView.isAutomaticLinkDetectionEnabled = self.isAutomaticLinkDetectionEnabled
        textView.isAutomaticSpellingCorrectionEnabled = self.isAutomaticSpellingCorrectionEnabled
        textView.isAutomaticTextCompletionEnabled = self.isAutomaticTextCompletionEnabled
        textView.isAutomaticTextReplacementEnabled = self.isAutomaticTextReplacementEnabled
        textView.isContinuousSpellCheckingEnabled = self.isContinuousSpellCheckingEnabled
        textView.isGrammarCheckingEnabled = self.isGrammarCheckingEnabled

        textView.string = text
        return scrollView
    }

    public func updateNSView(_ nsView: NSScrollView, context: Context) {
        //        guard let textView = nsView.documentView as? NSTextView else {
        //            return
        //        }
        //        textView.string = text
    }

    public class Coordinator: NSObject, NSTextViewDelegate {
        var parent: PatientTextEditor

        init(_ parent: PatientTextEditor) {
            self.parent = parent
        }

        public func textDidEndEditing(_ notification: Notification) {
            guard let textView = notification.object as? NSTextView else {
                return
            }
            parent.text = textView.string
        }
    }
}

public struct PatientAttributedTextEditor: NSViewRepresentable {
    @Binding var text: NSAttributedString

    public init(text: Binding<NSAttributedString>) {
        self._text = text
    }

    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    public func makeNSView(context: Context) -> NSScrollView {
        let scrollView = NSScrollView()
        let textView = NSTextView()

        scrollView.hasVerticalScroller = true
        scrollView.documentView = textView

        textView.delegate = context.coordinator
        textView.isVerticallyResizable = true
        textView.autoresizingMask = [.width]
        textView.textContainer?.containerSize = CGSize(width: textView.bounds.width, height: CGFloat.infinity)
        textView.textContainer?.widthTracksTextView = true

        textView.font = NSFont.monospacedSystemFont(ofSize: 11, weight: .regular)
        textView.isRichText = true
        textView.usesFontPanel = true

        textView.allowsUndo = true

        textView.isIncrementalSearchingEnabled = true
        textView.usesFindBar = true

        textView.isAutomaticDataDetectionEnabled = true
        textView.isAutomaticLinkDetectionEnabled = true
        textView.isAutomaticSpellingCorrectionEnabled = true
        textView.isAutomaticTextCompletionEnabled = true
        textView.isAutomaticTextReplacementEnabled = true
        textView.isContinuousSpellCheckingEnabled = true
        textView.isGrammarCheckingEnabled = true

        textView.usesRuler = true
        textView.isRulerVisible = true

        textView.usesRolloverButtonForSelection = true

        textView.textStorage?.setAttributedString(text)
        return scrollView
    }

    public func updateNSView(_ nsView: NSScrollView, context: Context) {
        //        guard let textView = nsView.documentView as? NSTextView else {
        //            return
        //        }
        //        textView.textStorage?.setAttributedString(text)
    }

    public class Coordinator: NSObject, NSTextViewDelegate {
        var parent: PatientAttributedTextEditor

        init(_ parent: PatientAttributedTextEditor) {
            self.parent = parent
        }

        public func textDidEndEditing(_ notification: Notification) {
            guard let textView = notification.object as? NSTextView else {
                return
            }
            parent.text = textView.attributedString()
        }
    }
}
#endif

#if DEBUG
struct ContentView: View {
    @State private var text: String = "Hello, SwiftUI!"

    var body: some View {
        VStack {
            PatientTextEditor(text: $text)
                .frame(width: 300, height: 200, alignment: .center)
                .border(Color.gray)
            PatientTextField(text: $text)
            Text(text)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif

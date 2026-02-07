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

#Preview("Patient Text Components") {
    struct PatientTextDemo: View {
        @State private var textFieldText: String = "Edit me slowly..."
        @State private var textEditorText: String = "This is a patient text editor.\n\nYou can edit text here and it will only update the binding when you finish editing or commit the changes.\n\nThis prevents excessive updates during typing."
        @State private var attributedText: NSAttributedString = {
            let attributed = NSMutableAttributedString(string: "Rich Text Editor\n\nThis supports attributed text with different styles.")
            #if canImport(AppKit)
            attributed.addAttribute(.foregroundColor, value: NSColor.systemBlue, range: NSRange(location: 0, length: 17))
            attributed.addAttribute(.font, value: NSFont.boldSystemFont(ofSize: 16), range: NSRange(location: 0, length: 17))
            #endif
            return attributed
        }()
        
        var body: some View {
            ScrollView {
                VStack(spacing: 25) {
                    Text("Patient Text Components")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    VStack(spacing: 15) {
                        Text("PatientTextField")
                            .font(.headline)
                        
                        Text("Only updates binding when editing ends or user commits")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        PatientTextField("Enter text here...", text: $textFieldText)
                            .textFieldStyle(.roundedBorder)
                        
                        Text("Current bound value:")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text("\"\(textFieldText)\"")
                            .font(.body)
                            .padding()
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(8)
                    }
                    .padding()
                    .background(Color.blue.opacity(0.05))
                    .cornerRadius(12)
                    
                    #if canImport(AppKit)
                    VStack(spacing: 15) {
                        Text("PatientTextEditor (macOS)")
                            .font(.headline)
                        
                        Text("Advanced text editor with customizable features")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        PatientTextEditor(text: $textEditorText)
                            .frame(height: 150)
                            .border(Color.gray.opacity(0.3))
                            .cornerRadius(4)
                        
                        Text("Current bound value: \(textEditorText.count) characters")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(Color.green.opacity(0.05))
                    .cornerRadius(12)
                    
                    VStack(spacing: 15) {
                        Text("PatientAttributedTextEditor (macOS)")
                            .font(.headline)
                        
                        Text("Rich text editor supporting attributed strings")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        PatientAttributedTextEditor(text: $attributedText)
                            .frame(height: 120)
                            .border(Color.gray.opacity(0.3))
                            .cornerRadius(4)
                        
                        Text("Supports rich formatting, ruler, and advanced text features")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(Color.orange.opacity(0.05))
                    .cornerRadius(12)
                    #endif
                    
                    #if !canImport(AppKit)
                    VStack {
                        Text("PatientTextEditor")
                            .font(.headline)
                        
                        Text("Advanced text editors are available on macOS")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                        
                        Image(systemName: "laptopcomputer")
                            .font(.system(size: 50))
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .background(Color.gray.opacity(0.05))
                    .cornerRadius(12)
                    #endif
                    
                    VStack(spacing: 10) {
                        Text("Key Features")
                            .font(.headline)
                        
                        VStack(alignment: .leading, spacing: 5) {
                            Text("• Reduces excessive binding updates during typing")
                            Text("• Updates only on focus loss or explicit commit")
                            Text("• Maintains smooth typing experience")
                            Text("• Perfect for expensive operations on text changes")
                        }
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(Color.purple.opacity(0.05))
                    .cornerRadius(12)
                }
                .padding()
            }
        }
    }
    
    return PatientTextDemo()
}

#if DEBUG
struct ContentView: View {
    @State private var text: String = "Hello, SwiftUI!"

    var body: some View {
        VStack {
            #if canImport(AppKit)
            PatientTextEditor(text: $text)
                .frame(width: 300, height: 200, alignment: .center)
                .border(Color.gray)
            #endif
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

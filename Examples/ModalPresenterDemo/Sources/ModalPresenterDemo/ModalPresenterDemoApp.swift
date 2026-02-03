import SwiftUI
import SwiftUIEnhancement

@main
struct ModalPresenterDemoApp: App {
    var body: some Scene {
        WindowGroup {
            DemoHomeView()
        }
        .windowStyle(.titleBar)
    }
}

@MainActor
final class DemoLog: ObservableObject {
    @Published var entries: [String] = []

    func add(_ message: String) {
        entries.append(message)
    }
}

struct DemoHomeView: View {
    @StateObject private var log = DemoLog()

    @StateObject private var sheetPresenter = SheetPresenter<TextInputModal>()
    @StateObject private var popoverPresenter = PopoverPresenter<TextInputModal>()
    @State private var windowPresenter = MacWindowPresenter<TextInputModal>()

    @StateObject private var alertPresenter = AlertPresenter<AlertActions, AlertMessage>(
        title: "Confirm Action",
        message: { AlertMessage() }
    )

    @StateObject private var dialogPresenter = DialogPresenter<DialogActions, DialogMessage>(
        title: "Pick an Option",
        titleVisibility: .visible,
        message: { DialogMessage() }
    )

    @StateObject private var anySheetPresenter = AnySheetPresenter()

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            header
            presenters
            Divider()
            logView
        }
        .padding(20)
        .frame(minWidth: 780, minHeight: 640)
        .sheetPresenter(sheetPresenter)
        .popoverPresenter(popoverPresenter)
        .alertPresenter(alertPresenter)
        .dialogPresenter(dialogPresenter)
        .anySheetPresenter(anySheetPresenter)
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Modal Presenter Demo")
                .font(.title)
                .bold()
            Text("Each button starts an async task, suspends until the user acts, then resumes and logs the result.")
                .foregroundStyle(.secondary)
        }
    }

    private var presenters: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                Button("Run Sheet (Typed)") {
                    Task { await runSheetFlow() }
                }
                Button("Run Popover (Typed)") {
                    Task { await runPopoverFlow() }
                }
                Button("Run Window (Typed)") {
                    Task { await runWindowFlow() }
                }
            }

            HStack(spacing: 12) {
                Button("Run Alert (Typed)") {
                    Task { await runAlertFlow() }
                }
                Button("Run Dialog (Typed)") {
                    Task { await runDialogFlow() }
                }
                Button("Run Sheet (Any)") {
                    Task { await runAnySheetFlow() }
                }
            }

            Text("Note: FullScreenCover presenters are iOS-only, so they are not shown in this macOS demo.")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }

    private var logView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Event Log")
                .font(.headline)
            ScrollView {
                VStack(alignment: .leading, spacing: 6) {
                    ForEach(Array(log.entries.enumerated()), id: \ .offset) { _, entry in
                        Text(entry)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(8)
                            .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 8))
                    }
                }
            }
        }
    }

    private func runSheetFlow() async {
        let runner = AsyncUIRunner(presenter: sheetPresenter)
        log.add("Sheet: waiting for input...")
        do {
            let value = try await runner.run(TextInputModal.self)
            log.add("Sheet: resumed with \(value)")
        } catch {
            log.add("Sheet: cancelled or failed (\(error.localizedDescription))")
        }
    }

    private func runPopoverFlow() async {
        let runner = AsyncUIRunner(presenter: popoverPresenter)
        log.add("Popover: waiting for input...")
        do {
            let value = try await runner.run(TextInputModal.self)
            log.add("Popover: resumed with \(value)")
        } catch {
            log.add("Popover: cancelled or failed (\(error.localizedDescription))")
        }
    }

    private func runWindowFlow() async {
        let runner = AsyncUIRunner(presenter: windowPresenter)
        log.add("Window: waiting for input...")
        do {
            let value = try await runner.run(TextInputModal.self)
            log.add("Window: resumed with \(value)")
        } catch {
            log.add("Window: cancelled or failed (\(error.localizedDescription))")
        }
    }

    private func runAlertFlow() async {
        let runner = AsyncUIRunner(presenter: alertPresenter)
        log.add("Alert: awaiting confirmation...")
        do {
            let value = try await runner.run(AlertActions.self)
            log.add("Alert: user confirmed = \(value ? "true" : "false")")
        } catch {
            log.add("Alert: cancelled or failed (\(error.localizedDescription))")
        }
    }

    private func runDialogFlow() async {
        let runner = AsyncUIRunner(presenter: dialogPresenter)
        log.add("Dialog: awaiting choice...")
        do {
            let choice = try await runner.run(DialogActions.self)
            log.add("Dialog: selected \(choice)")
        } catch {
            log.add("Dialog: cancelled or failed (\(error.localizedDescription))")
        }
    }

    private func runAnySheetFlow() async {
        let runner = AsyncUIRunner(presenter: anySheetPresenter)
        log.add("Any Sheet: waiting for input...")
        do {
            let value = try await runner.runAny { handle in
                TextInputModal(handle: handle)
            }
            log.add("Any Sheet: resumed with \(value)")
        } catch {
            log.add("Any Sheet: cancelled or failed (\(error.localizedDescription))")
        }
    }
}

struct TextInputModal: View, AwaitableModalView {
    typealias Output = String

    let handle: ModalHandle<String>
    @State private var text = ""

    init(handle: ModalHandle<String>) {
        self.handle = handle
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Enter a value")
                .font(.headline)
            TextField("Type here", text: $text)
                .textFieldStyle(.roundedBorder)
            HStack {
                Button("Cancel") { handle.cancel() }
                Spacer()
                Button("Submit") { handle.finish(text) }
                    .disabled(text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    .keyboardShortcut(.defaultAction)
            }
        }
        .padding(20)
        .frame(width: 360)
    }
}

struct AlertActions: View, AwaitableModalView {
    typealias Output = Bool

    let handle: ModalHandle<Bool>

    init(handle: ModalHandle<Bool>) {
        self.handle = handle
    }

    var body: some View {
        Button("Cancel", role: .cancel) {
            handle.finish(false)
        }
        Button("OK", role: .destructive) {
            handle.finish(true)
        }
    }
}

struct AlertMessage: View {
    var body: some View {
        Text("This alert suspends the async task until the user responds.")
    }
}

struct DialogActions: View, AwaitableModalView {
    typealias Output = String

    let handle: ModalHandle<String>

    init(handle: ModalHandle<String>) {
        self.handle = handle
    }

    var body: some View {
        Button("Option A") { handle.finish("Option A") }
        Button("Option B") { handle.finish("Option B") }
        Button("Cancel", role: .cancel) { handle.cancel() }
    }
}

struct DialogMessage: View {
    var body: some View {
        Text("Choose an option to resume the async flow.")
    }
}

import AppKit
import Combine
import SwiftUI

public struct NSPopoverHolderView<T: View>: NSViewRepresentable {
    @Binding var isVisible: Bool
    let sizePublisher: AnyPublisher<CGSize, Never>
    var content: () -> T

    public init(
        isVisible: Binding<Bool>,
        sizePublisher: AnyPublisher<CGSize, Never>,
        @ViewBuilder content: @escaping () -> T
    ) {
        self._isVisible = isVisible
        self.content = content
        self.sizePublisher = sizePublisher
    }

    public func makeNSView(context: Context) -> NSView {
        NSView()
    }

    public func updateNSView(_ nsView: NSView, context: Context) {
        context.coordinator.setVisible(isVisible, in: nsView)
    }

    public func makeCoordinator() -> Coordinator {
        Coordinator(self, sizePublisher: sizePublisher)
    }

    public class Coordinator: NSObject, NSPopoverDelegate {
        var parent: NSPopoverHolderView
        let sizePublisher: AnyPublisher<CGSize, Never>
        var cancellables = Set<AnyCancellable>()

        private let popover: NSPopover

        init(_ parent: NSPopoverHolderView, sizePublisher: AnyPublisher<CGSize, Never>) {
            self.parent = parent
            self.sizePublisher = sizePublisher
            self.popover = NSPopover()

            super.init()

            popover.delegate = self
            let host = NSHostingController(rootView: parent.content())
            popover.contentViewController = host
            popover.behavior = .transient
            popover.animates = false

            sizePublisher
                .removeDuplicates()
                .debounce(for: .seconds(0.4), scheduler: RunLoop.main)
                .sink { [weak self] newSize in
                    self?.popover.contentSize = newSize
                }
                .store(in: &cancellables)
        }

        func setVisible(_ isVisible: Bool, in view: NSView) {
            if isVisible {
                popover.show(relativeTo: view.bounds, of: view, preferredEdge: .minY)
            } else {
                popover.close()
            }
        }

        public func popoverDidClose(_ notification: Notification) {
            parent.isVisible = false
        }

        public func popoverShouldDetach(_ popover: NSPopover) -> Bool {
            true
        }
    }
}

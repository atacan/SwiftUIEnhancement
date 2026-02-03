import SwiftUI

@MainActor
public final class ModalHandle<Output> {
    private var completed = false
    private let onFinish: (Result<Output, Error>) -> Void
    private let onDismiss: () -> Void

    init(onDismiss: @escaping () -> Void,
         onFinish: @escaping (Result<Output, Error>) -> Void) {
        self.onDismiss = onDismiss
        self.onFinish = onFinish
    }

    public func finish(_ value: Output) {
        guard !completed else { return }
        completed = true
        onDismiss()
        onFinish(.success(value))
    }

    public func cancel() {
        fail(CancellationError())
    }

    public func fail(_ error: Error) {
        guard !completed else { return }
        completed = true
        onDismiss()
        onFinish(.failure(error))
    }
}

@MainActor
public protocol ModalPresenter {
    associatedtype Token

    func present<Content: View>(
        _ content: Content,
        onUserCancel: @escaping () -> Void
    ) -> Token

    func dismiss(_ token: Token)
}

@MainActor
public final class AsyncUIRunner<P: ModalPresenter> {
    private let presenter: P

    public init(presenter: P) {
        self.presenter = presenter
    }

    public func run<Output, Content: View>(
        @ViewBuilder content: @escaping (ModalHandle<Output>) -> Content
    ) async throws -> Output {
        try await withCheckedThrowingContinuation { continuation in
            var token: P.Token?

            let handle = ModalHandle<Output>(
                onDismiss: {
                    guard let token else { return }
                    self.presenter.dismiss(token)
                },
                onFinish: { result in
                    switch result {
                    case .success(let output):
                        continuation.resume(returning: output)
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                }
            )

            token = presenter.present(content(handle), onUserCancel: {
                handle.cancel()
            })
        }
    }
}

public protocol AwaitableModalView: View {
    associatedtype Output
    init(handle: ModalHandle<Output>)
}

public extension AsyncUIRunner {
    func run<V: AwaitableModalView>(_ viewType: V.Type = V.self) async throws -> V.Output {
        try await run { handle in
            V(handle: handle)
        }
    }
}

import SwiftUI

public extension AsyncView where Failure == Never, LoadingView == ProgressView<EmptyView, EmptyView>, FailureView == EmptyView {
    init(
        options: AsyncViewOptions = .automatic,
        operation: @Sendable @escaping () async -> Success,
        @ViewBuilder content: @escaping (_ value: Success) -> SuccessView
    ) {
        self.init(
            options: options,
            operation: operation,
            content: content,
            loading: {
                ProgressView()
            },
            failure: { _ in
            }
        )
    }
}

public extension AsyncView where LoadingView == ProgressView<EmptyView, EmptyView> {
    init(
        options: AsyncViewOptions = .automatic,
        operation: @Sendable @escaping () async throws(Failure) -> Success,
        @ViewBuilder content: @escaping (_ value: Success) -> SuccessView,
        @ViewBuilder failure: @escaping (_ error: Failure) -> FailureView
    ) {
        self.init(
            options: options,
            operation: operation,
            content: content,
            loading: {
                ProgressView()
            },
            failure: failure
        )
    }
}

#Preview {
    AsyncView {
        42
    } content: { value in
        Text("success \(value)")
    }
}

#Preview {
    AsyncView {
        try! await Task.sleep(for: .seconds(5))
        if Bool.random() {
            return 42
        } else {
            throw SomeError()
        }
    } content: { value in
        Text("success \(value)")
    } failure: { error in
        Text("failure \(String(describing: error))")
    }
}

private struct SomeError: Error {}

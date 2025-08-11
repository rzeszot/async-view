import SwiftUI

public struct AsyncView<
    Success,
    Failure: Error,
    LoadingView: View,
    SuccessView: View,
    FailureView: View
>: View {
    private let options: AsyncViewOptions
    private let operation: AsyncOperation<Success, Failure>
    private let content: (Success) -> SuccessView
    private let loading: () -> LoadingView
    private let failure: (Failure) -> FailureView

    @State private var phase: Phase<Success, Failure> = .pending
    @State private var task: Task<Void, Never>?

    public init(
        options: AsyncViewOptions = .automatic,
        operation: @escaping AsyncOperation<Success, Failure>,
        @ViewBuilder content: @escaping (_ value: Success) -> SuccessView,
        @ViewBuilder loading: @escaping () -> LoadingView,
        @ViewBuilder failure: @escaping (_ error: Failure) -> FailureView
    ) {
        self.options = options
        self.operation = operation
        self.content = content
        self.loading = loading
        self.failure = failure
    }

    public var body: some View {
        let action = RefreshAction {
            phase = .pending
        }

        switch phase {
        case .pending:
            ZStack {
                loading()
            }
            .onAppear {
                task = Task {
                    phase = await Phase(operation: operation)
                }
            }
            .onDisappear {
                if options.contains(.autocancel) {
                    task?.cancel()
                    task = nil
                }
            }
        case let .success(value):
            content(value)
                .environment(\.refreshAction, action)
        case let .failure(error):
            failure(error)
                .environment(\.refreshAction, action)
        }
    }
}

#Preview("retry") {
    AsyncView(options: []) {
        try await Task.sleep(for: .seconds(2))
        if Bool.random() {
            throw CancellationError()
        } else {
            return 42
        }
    } content: { value in
        RefreshActionReader { refresh in
            VStack {
                Text("Success \(value)")
                Button("Refresh") {
                    refresh()
                }
            }
        }
    } loading: {
        ProgressView()
    } failure: { error in
        RefreshActionReader { refresh in
            VStack {
                Text("Failure \(String(describing: error))")
                Button("Refresh") {
                    refresh()
                }
            }
        }
    }
}

#Preview("autocancel") {
    NavigationStack {
        VStack {
            NavigationLink("lorem") {
                Text("lorem")
            }
            Divider()
            AsyncView(options: [.autocancel]) {
                try await Task.sleep(for: .seconds(5))
                return 42
            } content: { value in
                Text("success \(value)")
            } loading: {
                ProgressView()
            } failure: { error in
                Text("failure \(String(describing: error))")
            }
        }
    }
}

#Preview("no-autocancel") {
    NavigationStack {
        VStack {
            NavigationLink("lorem") {
                Text("lorem")
            }
            Divider()
            AsyncView(options: []) {
                try await Task.sleep(for: .seconds(5))
                return 42
            } content: { value in
                Text("success \(value)")
            } loading: {
                ProgressView()
            } failure: { error in
                Text("failure \(String(describing: error))")
            }
        }
    }
}

#Preview("loading-bug") {
    AsyncView(options: []) {
        try await Task.sleep(for: .seconds(5))
        return 42
    } content: { value in
        Text("success \(value)")
    } loading: {
        EmptyView()
    } failure: { error in
        Text("failure \(String(describing: error))")
    }
}

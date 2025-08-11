import SwiftUI

@MainActor
public struct RetryAction: Sendable {
    let handler: @MainActor () -> Void

    public func callAsFunction() {
        handler()
    }
}

public extension EnvironmentValues {
    @Entry var retryAction: RetryAction = .init {}
}

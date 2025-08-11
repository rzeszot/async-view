import SwiftUI

@MainActor public struct RefreshAction: Sendable {
    let handler: @MainActor () -> Void

    public func callAsFunction() {
        handler()
    }
}

public extension EnvironmentValues {
    @Entry var refreshAction: RefreshAction = .init {}
}

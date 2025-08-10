import Foundation

public struct AsyncViewOptions: OptionSet, Sendable {
    public let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
}

public extension AsyncViewOptions {
    static let autocancel = Self(rawValue: 1 << 0)

    static let automatic: Self = [.autocancel]
}

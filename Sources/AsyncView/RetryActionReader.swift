import SwiftUI

public struct RetryActionReader<Content: View>: View {
    private let content: (RetryAction) -> Content

    @Environment(\.retryAction) private var action

    public init(content: @escaping (_ retry: RetryAction) -> Content) {
        self.content = content
    }

    public var body: some View {
        content(action)
    }
}

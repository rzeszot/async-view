import SwiftUI

public struct RefreshActionReader<Content: View>: View {
    private let content: (RefreshAction) -> Content

    @Environment(\.refreshAction) private var action

    public init(content: @escaping (_ refresh: RefreshAction) -> Content) {
        self.content = content
    }

    public var body: some View {
        content(action)
    }
}

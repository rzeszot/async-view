@testable import AsyncView
import Testing

@Suite struct AsyncViewOptionsTests {
    @Test func automatic() {
        #expect(AsyncViewOptions.automatic == [.autocancel])
    }
}

@testable import AsyncView
import Testing

@Suite struct PhaseTests {
    @Test func success() async {
        let sut = await prepare(.success(42))
        #expect(sut == .success(42))
    }

    @Test func failure() async {
        let sut = await prepare(.failure(FooBarError.foo))
        #expect(sut == .failure(FooBarError.foo))
    }

    func prepare(_ result: Result<Int, FooBarError>) async -> Phase<Int, FooBarError> {
        let operation: () throws(FooBarError) -> Int = {
            try result.get()
        }
        return await Phase(operation: operation)
    }

    enum FooBarError: Error, Equatable {
        case foo
        case bar
    }
}

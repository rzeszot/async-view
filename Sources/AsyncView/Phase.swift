import Foundation

enum Phase<
    Success: ~Copyable & ~Escapable,
    Failure: Error
> {
    case pending
    case success(Success)
    case failure(Failure)
}

extension Phase: Copyable where Success: Copyable & ~Escapable {}

extension Phase: Escapable where Success: Escapable & ~Copyable {}

extension Phase: Equatable where Success: Equatable, Failure: Equatable {}

extension Phase {
    init(operation: () async throws(Failure) -> Success) async {
        do throws(Failure) {
            let value = try await operation()
            self = .success(value)
        } catch {
            self = .failure(error)
        }
    }
}

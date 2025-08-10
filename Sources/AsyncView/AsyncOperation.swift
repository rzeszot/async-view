import Foundation

public typealias AsyncOperation<Success, Failure: Error> = @Sendable () async throws(Failure) -> Success

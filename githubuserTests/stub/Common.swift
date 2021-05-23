import Foundation
@testable import githubuser

enum MockResult {
    case success
    case failure(error: ServiceError)
    case failureUnknowError(error: MockError)
}

enum MockError: Error {
    case unknowError
}

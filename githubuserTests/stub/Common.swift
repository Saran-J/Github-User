import Foundation
@testable import githubuser

enum MockResult {
    case success
    case failure(error: ServiceError)
}

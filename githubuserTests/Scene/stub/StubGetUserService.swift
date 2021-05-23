import Foundation
import RxSwift
@testable import githubuser

class StubGetUserService: GetUserService {
    let resultCase: MockResult
    public init(mockResult: MockResult) {
        resultCase = mockResult
    }
    override func executeService(lastUserId: Int, perPage: Int) -> Observable<[UserItem]> {
        switch resultCase {
        case .success:
            return .just([])
        case .failure(let error):
            return .error(error)
        case .failureUnknowError(let error):
            return .error(error)
        }
    }
}

import Foundation
import RxSwift
@testable import githubuser

class StubGetUserRepoService: GetUserRepoService {
    let resultCase: MockResult
    public init(mockResult: MockResult) {
        resultCase = mockResult
    }
    override func executeService(
        user: String,
        page: Int,
        perPage: Int
    ) -> Observable<[GetUserRepoResponse]> {
        switch self.resultCase {
        case .success: return .just([MockUserReposResponse.getMock()])
        case .failure(let error): return .error(error)
        case .failureUnknowError(let error):
            return .error(error)
        }
    }
}

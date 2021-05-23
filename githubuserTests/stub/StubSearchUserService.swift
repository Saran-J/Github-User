import Foundation
import RxSwift
@testable import githubuser

class StubSearchUserService: SearchUserService {
    let resultCase: MockResult
    public init(mockResult: MockResult) {
        resultCase = mockResult
    }
    override func executeService(
        keyword: String,
        sort: SortData,
        page: Int,
        perPage: Int
    ) -> Observable<SearchUserResponse> {
        switch self.resultCase {
        case .success:
            return .just(MockSearchResponse.getMock())
        case .failure(let error): return .error(error)
        case .failureUnknowError(let error):
            return .error(error)
        }
    }
}

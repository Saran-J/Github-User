import Foundation
import RxSwift
@testable import githubuser

class StubSearchUserService: SearchUserService {
    override func executeService(
        keyword: String,
        sort: SortData,
        page: Int,
        perPage: Int
    ) -> Observable<SearchUserResponse> {
        let response = SearchUserResponse(
            totalCount: 0,
            incompleteResults: false,
            items: [])
        return .just(response)
    }
}

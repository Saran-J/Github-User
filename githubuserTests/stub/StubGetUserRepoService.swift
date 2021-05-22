import Foundation
import RxSwift
@testable import githubuser

class StubGetUserRepoService: GetUserRepoService {
    override func executeService(
        user: String,
        page: Int,
        perPage: Int
    ) -> Observable<[GetUserRepoResponse]> {
        return .just([])
    }
}

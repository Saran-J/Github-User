import Foundation
import RxSwift
@testable import githubuser

class StubGetUserService: GetUserService {
    override func executeService(lastUserId: Int, perPage: Int) -> Observable<[UserItem]> {
        return .just([])
    }
}

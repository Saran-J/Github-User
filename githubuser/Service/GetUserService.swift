import Foundation
import Moya
import RxSwift

struct UserItem: Codable {
    var id: Int64
}

class GetUserService: BaseService<UserProvider, UserItem> {
    func executeService(page: Int, perPage: Int) -> Observable<UserItem> {
        return super.callService(
            target: UserProvider.fetchUser(page: page, perPage: perPage))
    }
}

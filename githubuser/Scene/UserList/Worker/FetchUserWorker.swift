import Foundation
import RxSwift

protocol FetchUserWorkerProtocol: class {
    func fetchUserList(shouldReload: Bool) -> Observable<([UserItem], [UserFavoriteModel])>
}

class FetchUserWorker: FetchUserWorkerProtocol {
    var perPage: Int = 10
    var lastUserId: Int = 0
    var disposeBag = DisposeBag()
    var userListService = GetUserService()
    var favoriteWorker: FavoriteWorkerProtocol = FavoriteWorker()
    func fetchUserList(shouldReload: Bool) -> Observable<([UserItem], [UserFavoriteModel])> {
        if shouldReload {
            lastUserId = 0
        }
        let userListObservable = userListService.executeService(
            lastUserId: lastUserId,
            perPage: perPage)
        let favoriteUserObservable = favoriteWorker.fetchFavoriteUser(
            keyword: "",
            startIndex: 0,
            pagination: false
        )
        return
            Observable.zip(userListObservable, favoriteUserObservable)
            .do { [weak self] result in
                self?.lastUserId = toInt(result.0.last?.id)
            }
    }
}

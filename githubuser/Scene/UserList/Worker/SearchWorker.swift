import Foundation
import RxSwift

struct SearchUserResult {
    var userList: [UserItem]
    var favoriteList: [UserFavoriteModel]
    var isLastPage: Bool
}

protocol SearchWorkerProtocol: class {
    func searchUser(
        keyword: String,
        shouldReload: Bool,
        sort: SortData
    ) -> Observable<SearchUserResult>
}

class SearchWorker: SearchWorkerProtocol {
    var perPage: Int = 10
    var page: Int = 1
    var disposeBag = DisposeBag()
    var userList: [UserItem] = []
    var searchUserService = SearchUserService()
    var favoriteWorker: FavoriteWorkerProtocol = FavoriteWorker()
    func searchUser(
        keyword: String,
        shouldReload: Bool,
        sort: SortData
    ) -> Observable<SearchUserResult> {
        if shouldReload {
            self.userList = []
            page = 1
        } else {
            page += 1
        }
        let searchUserObservable = searchUserService.executeService(
            keyword: keyword,
            sort: sort,
            page: page,
            perPage: perPage
        )
        let favoriteUserObservable = favoriteWorker.fetchFavoriteUser(
            keyword: "",
            startIndex: 0,
            pagination: false)
        return Observable.zip(searchUserObservable, favoriteUserObservable)
        .map { [weak self] result -> SearchUserResult in
            let isLastPage = result.0.totalCount < toInt(self?.perPage)
            let searchResult = SearchUserResult(
                userList: result.0.items,
                favoriteList: result.1,
                isLastPage: isLastPage
            )
            return searchResult
        }
    }
}

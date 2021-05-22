import Foundation
import RxSwift

protocol FavoriteWorkerProtocol: class {
    func fetchFavoriteList(
        keyword: String,
        shouldReload: Bool,
        sort: SortData
    ) -> Observable<[UserItem]>
    func fetchFavoriteUser(keyword: String, startIndex: Int, pagination: Bool) -> Observable<[UserFavoriteModel]>
    func favoriteUser(userId: Int64, userName: String, isFavorite: Bool)
}

class FavoriteWorker: FavoriteWorkerProtocol {
    var perPage: Int = 10
    var page: Int = 1
    var lastUserId: Int = 0
    var disposeBag = DisposeBag()
    var userList: [UserItem] = []
    var searchUserService = SearchUserService()
    var coreDataWorker = CoreDataWorker()
    func fetchFavoriteList(
        keyword: String,
        shouldReload: Bool,
        sort: SortData
    ) -> Observable<[UserItem]> {
        if shouldReload {
            self.userList = []
            page = 0
        } else {
            page += 1
        }
        return
            self.fetchFavoriteUser(
                keyword: keyword,
                startIndex: page * perPage,
                pagination: true
            )
            .map { result -> String in
                var queryString = ""
                result.forEach { model in
                    queryString += "user:\(model.name) "
                }
                return queryString
            }
            .flatMap { query -> Observable<SearchUserResponse> in
                if query.isEmpty {
                    let response = SearchUserResponse(
                        totalCount: 0,
                        incompleteResults: false,
                        items: []
                    )
                    return Observable.just(response)
                }
                return
                    self.searchUserService.executeService(
                        keyword: query,
                        sort: sort,
                        page: 1,
                        perPage: self.perPage)
            }
            .map({ result -> [UserItem] in
                let favoriteResult = result.items.map { item -> UserItem in
                    var newItem = item
                    newItem.favorite = true
                    return newItem
                }
                return favoriteResult
            })
    }
    
    func fetchFavoriteUser(keyword: String = "", startIndex: Int = 0, pagination: Bool) -> Observable<[UserFavoriteModel]> {
        return coreDataWorker.fetchFavorite(
            keyword: keyword,
            startIndex: startIndex,
            pagination: pagination
        )
    }
    
    func favoriteUser(userId: Int64, userName: String, isFavorite: Bool) {
        if isFavorite {
            coreDataWorker.makeFavorite(userId: userId, uesrName: userName)
        } else {
            coreDataWorker.makeUnFavorite(userId: userId)
        }
    }
}

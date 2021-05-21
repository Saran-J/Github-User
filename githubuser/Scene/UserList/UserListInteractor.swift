import UIKit
import RxSwift

protocol UserListBusinessLogic {
    func queryUserList(request: UserList.QueryUser.Request)
    func favoriteUser(request: UserList.FavoriteUser.Request)
}

protocol UserListDataStore {
    var userList: [UserItem] { get set }
}

class UserListInteractor: UserListBusinessLogic, UserListDataStore {
    var perPage: Int = 10
    var page: Int = 1
    var lastUserId: Int = 0
    var disposeBag = DisposeBag()
    
    var presenter: UserListPresentationLogic?
    var userListService = GetUserService()
    var searchUserService = SearchUserService()
    var favoriteWorker = FavoriteWorker()
    var favoriteUserList: [UserFavoriteModel] = []
    var userList: [UserItem] = []
    
    func queryUserList(request: UserList.QueryUser.Request) {
        if request.keyword.isEmpty && request.sort != .bestMatch {
            presenter?.presentError(error: ServiceError(.needKeyword))
            return
        }
        
        if request.keyword.isEmpty {
            fetchUserList(shouldReload: request.shouldReload)
            return
        }
        searchUser(
            keyword: request.keyword,
            shouldReload: request.shouldReload,
            sort: request.sort)
    }
    
    func fetchUserList(shouldReload: Bool) {
        if shouldReload {
            lastUserId = 0
            self.userList = []
        }
        let userListObservable = userListService.executeService(
            lastUserId: lastUserId,
            perPage: perPage)
        let favoriteUserObservable = fetchFavoriteUser()
        Observable.zip(userListObservable, favoriteUserObservable)
        .map { result in
            self.updateFavoriteUserList(
            userList: result.0,
            favoriteList: result.1)
        }
        .subscribe { [weak self] userList in
            self?.lastUserId = userList.last?.id ?? 0
            self?.userList.append(contentsOf: userList)
            let response = UserList.QueryUser.Response(
                searchResponse: userList,
                shouldReload: shouldReload,
                isLastPage: userList.count < toInt(self?.perPage))
            self?.presenter?.presentUserList(response: response)
        } onError: { [weak self] error in
            let serviceError = (error as? ServiceError) ?? ServiceError(.unknownError)
            self?.presenter?.presentError(error: serviceError)
        }
        .disposed(by: disposeBag)
    }
    
    private func fetchFavoriteUser() -> Observable<[UserFavoriteModel]> {
        return favoriteWorker.fetchFavorite()
            .do { [weak self] favoriteList in
                self?.favoriteUserList = favoriteList
            }
    }
    
    private func updateFavoriteUserList(
        userList: [UserItem],
        favoriteList: [UserFavoriteModel]
    ) -> [UserItem] {
        let newResult = userList.map { item -> UserItem in
            let isFavoorite = favoriteList.first { model -> Bool in
                return model.id == Int64(toInt(item.id))
            }?.isFavorite ?? false
            var newItem = item
            newItem.favorite = isFavoorite
            return newItem
        }
        return newResult
    }
    
    func searchUser(keyword: String, shouldReload: Bool, sort: SortData) {
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
        let favoriteUserObservable = fetchFavoriteUser()
        Observable.zip(searchUserObservable, favoriteUserObservable)
        .map { [weak self] result -> ([UserItem], Bool) in
            let userList = self?.updateFavoriteUserList(
                userList: result.0.items,
                favoriteList: result.1) ?? []
            let isLastPage = result.0.totalCount < toInt(self?.perPage)
            return (userList, isLastPage)
        }
        .subscribe { [weak self] searchResponse in
            self?.userList.append(contentsOf: searchResponse.0)
            let response = UserList.QueryUser.Response(
                searchResponse: searchResponse.0,
                shouldReload: shouldReload,
                isLastPage: searchResponse.1)
            self?.presenter?.presentUserList(response: response)
        } onError: { error in
            print(error)
        }
        .disposed(by: disposeBag)
    }
    
    func favoriteUser(request: UserList.FavoriteUser.Request) {
        if request.favorite {
            favoriteWorker.makeFavorite(userId: request.userId)
        } else {
            favoriteWorker.makeUnFavorite(userId: request.userId)
        }
    }
}

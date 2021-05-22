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
    var disposeBag = DisposeBag()
    var userList: [UserItem] = []

    var coreDataWorker = CoreDataWorker()
    var favoriteWorker: FavoriteWorkerProtocol = FavoriteWorker()
    var searchWorker: SearchWorkerProtocol = SearchWorker()
    var fetchUserWorker: FetchUserWorkerProtocol = FetchUserWorker()
    
    var presenter: UserListPresentationLogic?
    
    func queryUserList(request: UserList.QueryUser.Request) {
        if request.filter == .favorite {
            fetchFavoriteList(
                keyword: request.keyword,
                shouldReload: request.shouldReload,
                sort: request.sort
            )
            return
        }
        
        if request.keyword.isEmpty && request.sort == .bestMatch {
            fetchUserList(shouldReload: request.shouldReload)
            return
        }
        
        searchUser(
            keyword: request.keyword,
            shouldReload: request.shouldReload,
            sort: request.sort)
    }
    
    func fetchFavoriteList(keyword: String, shouldReload: Bool, sort: SortData) {
        if shouldReload {
            self.userList = []
        }
        favoriteWorker.fetchFavoriteList(
            keyword: keyword,
            shouldReload: shouldReload,
            sort: sort
        )
        .subscribe { [weak self] result in
            self?.userList.append(contentsOf: result)
            let response = UserList.QueryUser.Response(
                searchResponse: result,
                shouldReload: shouldReload,
                isLastPage: result.count < toInt(self?.perPage))
            self?.presenter?.presentUserList(response: response)
        } onError: { [weak self] error in
            let serviceError = (error as? ServiceError) ?? ServiceError(.unknownError)
            self?.presenter?.presentError(error: serviceError)
        }
        .disposed(by: disposeBag)
    }
    
    func fetchUserList(shouldReload: Bool) {
        if shouldReload {
            self.userList = []
        }
        fetchUserWorker.fetchUserList(shouldReload: shouldReload)
        .map { result in
            self.updateFavoriteUserList(
            userList: result.0,
            favoriteList: result.1)
        }
        .subscribe { [weak self] userList in
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
    
    func searchUser(keyword: String, shouldReload: Bool, sort: SortData) {
        if shouldReload {
            self.userList = []
        }
        searchWorker.searchUser(
            keyword: keyword,
            shouldReload: shouldReload,
            sort: sort
        )
        .map { [weak self] result -> ([UserItem], Bool) in
            let userList = self?.updateFavoriteUserList(
                userList: result.userList,
                favoriteList: result.favoriteList) ?? []
            return (userList, result.isLastPage)
        }
        .subscribe { [weak self] searchResponse in
            self?.userList.append(contentsOf: searchResponse.0)
            let response = UserList.QueryUser.Response(
                searchResponse: searchResponse.0,
                shouldReload: shouldReload,
                isLastPage: searchResponse.1)
            self?.presenter?.presentUserList(response: response)
        } onError: { [weak self] error in
            let serviceError = (error as? ServiceError) ?? ServiceError(.unknownError)
            self?.presenter?.presentError(error: serviceError)
        }
        .disposed(by: disposeBag)
    }
    
    func favoriteUser(request: UserList.FavoriteUser.Request) {
        favoriteWorker.favoriteUser(
            userId: request.userId,
            userName: request.userName,
            isFavorite: request.favorite
        )
    }
    
    private func updateFavoriteUserList(
        userList: [UserItem],
        favoriteList: [UserFavoriteModel]
    ) -> [UserItem] {
        let newResult = userList.map { item -> UserItem in
            let isFavoorite = favoriteList.first { model -> Bool in
                return model.id == Int64(toInt(item.id))
            } != nil
            var newItem = item
            newItem.favorite = isFavoorite
            return newItem
        }
        return newResult
    }
}

import UIKit
import RxSwift

protocol UserListBusinessLogic {
    func fetchUserList(request: UserList.FetchUserList.Request)
    func searchUser(request: UserList.SearchUser.Request)
}

protocol UserListDataStore {
}

class UserListInteractor: UserListBusinessLogic, UserListDataStore {
    var perPage: Int = 10
    var pageNo: Int = 0
    var disposeBag = DisposeBag()
    
    var presenter: UserListPresentationLogic?
    var userListService = GetUserService()
    var searchUserService = SearchUserService()
    func fetchUserList(request: UserList.FetchUserList.Request) {
        userListService.executeService(page: pageNo, perPage: perPage)
            .subscribe { [weak self] userList in
                let response = UserList.FetchUserList.Response(
                    userListRespnse: userList,
                    shouldReload: request.shouldReload)
                self?.presenter?.presentUserList(response: response)
            } onError: { error in
                print(error)
            }
        .disposed(by: disposeBag)
    }
    
    func searchUser(request: UserList.SearchUser.Request) {
        searchUserService.executeService(keyword: request.keyword)
            .subscribe { [weak self] searchResponse in
                let response = UserList.SearchUser.Response(
                    searchResponse: searchResponse,
                    shouldReload: request.shouldReload)
                self?.presenter?.presentSearchUser(response: response)
            } onError: { error in
                print(error)
            }
        .disposed(by: disposeBag)
    }
}

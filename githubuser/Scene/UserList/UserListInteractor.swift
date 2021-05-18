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
            .subscribe { userList in
                print(userList)
            } onError: { error in
                print(error)
            }
        .disposed(by: disposeBag)
    }
    
    func searchUser(request: UserList.SearchUser.Request) {
        searchUserService.executeService(keyword: request.keyword)
            .subscribe { searchResponse in
                print(searchResponse)
            } onError: { error in
                print(error)
            }
        .disposed(by: disposeBag)
    }
}

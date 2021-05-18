import UIKit

protocol UserListPresentationLogic {
    func presentUserList(response: UserList.FetchUserList.Response)
    func presentSearchUser(response: UserList.SearchUser.Response)
}

class UserListPresenter: UserListPresentationLogic {
    weak var viewController: UserListDisplayLogic?
    
    func presentUserList(response: UserList.FetchUserList.Response) {
    }
    
    func presentSearchUser(response: UserList.SearchUser.Response) {
    }
}

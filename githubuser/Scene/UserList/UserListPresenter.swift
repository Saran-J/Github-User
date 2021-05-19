import UIKit

protocol UserListPresentationLogic {
    func presentUserList(response: UserList.FetchUserList.Response)
    func presentSearchUser(response: UserList.SearchUser.Response)
}

class UserListPresenter: UserListPresentationLogic {
    weak var viewController: UserListDisplayLogic?
    
    func presentUserList(response: UserList.FetchUserList.Response) {
        var userList: [UserListObject] = []
        response.userListRespnse.forEach { user in
            let userObject = UserListObject(
                name: toString(user.login),
                url: toString(user.url),
                avatarImageUrl: toString(user.avatarUrl))
            userList.append(userObject)
        }
        let viewModel = UserList.FetchUserList.ViewModel(
            userListDisplay: userList,
            shouldReload: response.shouldReload)
        viewController?.displayUserList(viewModel: viewModel)
    }
    
    func presentSearchUser(response: UserList.SearchUser.Response) {
        var userList: [UserListObject] = []
        response.searchResponse.items.forEach { user in
            let userObject = UserListObject(
                name: toString(user.login),
                url: toString(user.url),
                avatarImageUrl: toString(user.avatarUrl))
            userList.append(userObject)
        }
        let viewModel = UserList.SearchUser.ViewModel(
            userListDisplay: userList,
            shouldReload: response.shouldReload)
        viewController?.displaySearchUser(viewModel: viewModel)
    }
}

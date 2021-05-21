import UIKit

protocol UserListPresentationLogic {
    func presentUserList(response: UserList.QueryUser.Response)
    func presentError(error: ServiceError)
}

class UserListPresenter: UserListPresentationLogic {
    weak var viewController: UserListDisplayLogic?
    
    func presentUserList(response: UserList.QueryUser.Response) {
        var userList: [UserListObject] = []
        response.searchResponse.forEach { user in
            let userObject = UserListObject(
                id: Int64(toInt(user.id)),
                name: toString(user.login),
                url: toString(user.url),
                avatarImageUrl: toString(user.avatarUrl),
                isFavorite: toBool(user.favorite))
            userList.append(userObject)
        }
        let viewModel = UserList.QueryUser.ViewModel(
            userListDisplay: userList,
            shouldReload: response.shouldReload,
            isLastPage: response.isLastPage)
        viewController?.displayUserList(viewModel: viewModel)
    }
    
    func presentError(error: ServiceError) {
        viewController?.displayError(error: error)
    }
}

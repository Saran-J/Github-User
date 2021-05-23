import Foundation
@testable import githubuser

class UserListViewControllerSpy: UserListDisplayLogic {
    var countDisplayUserList = 0
    var countDisplayError = 0
    func displayUserList(viewModel: UserList.QueryUser.ViewModel) {
        countDisplayUserList += 1
    }
    
    func displayError(error: ServiceError) {
        countDisplayError += 1
    }
}

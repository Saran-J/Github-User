import Foundation
@testable import githubuser

class UserListPresenterSpy: UserListPresentationLogic {
    var countPresentUserList = 0
    var countPresentError = 0
    func presentUserList(response: UserList.QueryUser.Response) {
        countPresentUserList += 1
    }
    
    func presentError(error: ServiceError) {
        countPresentError += 1
    }
}

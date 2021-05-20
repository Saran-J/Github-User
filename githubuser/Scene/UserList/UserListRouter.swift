import UIKit

@objc protocol UserListRoutingLogic {
    func routeToUserRepositoryList(id: Int)
}

protocol UserListDataPassing {
    var dataStore: UserListDataStore? { get }
}

class UserListRouter: NSObject, UserListRoutingLogic, UserListDataPassing {
    weak var viewController: UserListViewController?
    var dataStore: UserListDataStore?
    
    func routeToUserRepositoryList(id: Int) {
        guard
            let userItem = dataStore?.userList.first(where: { item -> Bool in
                item.id == id
            }),
            let destination = UserReposViewController.initFromStoryboard()
        else { return }
        var destinationDS = destination.router?.dataStore
        destinationDS?.userItem = userItem
        viewController?.navigationController?.pushViewController(destination, animated: true)
    }
}

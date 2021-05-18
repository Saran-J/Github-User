import UIKit

@objc protocol UserListRoutingLogic {
}

protocol UserListDataPassing {
    var dataStore: UserListDataStore? { get }
}

class UserListRouter: NSObject, UserListRoutingLogic, UserListDataPassing {
    weak var viewController: UserListViewController?
    var dataStore: UserListDataStore?
}

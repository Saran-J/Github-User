import UIKit

@objc protocol UserReposRoutingLogic {
}

protocol UserReposDataPassing {
    var dataStore: UserReposDataStore? { get }
}

class UserReposRouter: NSObject, UserReposRoutingLogic, UserReposDataPassing {
    weak var viewController: UserReposViewController?
    var dataStore: UserReposDataStore?
}

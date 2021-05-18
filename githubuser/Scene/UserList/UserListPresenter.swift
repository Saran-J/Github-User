import UIKit

protocol UserListPresentationLogic {}

class UserListPresenter: UserListPresentationLogic {
    weak var viewController: UserListDisplayLogic?
}

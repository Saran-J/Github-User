import UIKit

protocol UserListBusinessLogic {
}

protocol UserListDataStore {
}

class UserListInteractor: UserListBusinessLogic, UserListDataStore {
    var presenter: UserListPresentationLogic?
}

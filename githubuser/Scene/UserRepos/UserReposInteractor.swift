import UIKit

protocol UserReposBusinessLogic {
}

protocol UserReposDataStore {
}

class UserReposInteractor: UserReposBusinessLogic, UserReposDataStore {
    var presenter: UserReposPresentationLogic?
    var worker: UserReposWorker?
}

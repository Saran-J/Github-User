import UIKit

protocol UserReposBusinessLogic {
    func fetchUserRepository(request: UserRepos.FetchUserRepository.Request)
}

protocol UserReposDataStore {
}

class UserReposInteractor: UserReposBusinessLogic, UserReposDataStore {
    var presenter: UserReposPresentationLogic?
    func fetchUserRepository(request: UserRepos.FetchUserRepository.Request) {
    }
}

import UIKit

protocol UserReposPresentationLogic {
    func presentUserRepository(response: UserRepos.FetchUserRepository.Response)
}

class UserReposPresenter: UserReposPresentationLogic {
    weak var viewController: UserReposDisplayLogic?
    
    func presentUserRepository(response: UserRepos.FetchUserRepository.Response) {
    }
}

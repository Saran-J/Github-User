import Foundation
@testable import githubuser

class UserReposViewControllerSpy: UserReposDisplayLogic {
    var countDisplayUserRepository = 0
    var countDisplayError = 0
    func displayUserRepository(viewModel: UserRepos.FetchUserRepository.ViewModel) {
        countDisplayUserRepository += 1
    }
    
    func displayError(title: String, message: String) {
        countDisplayError += 1
    }
}

import Foundation
@testable import githubuser

class UserReposPresenterSpy: UserReposPresentationLogic {
    var countPresentUserRepository = 0
    var countPresentError = 0
    func presentUserRepository(response: UserRepos.FetchUserRepository.Response) {
        countPresentUserRepository += 1
    }
    
    func presentError(error: ServiceError) {
        countPresentError += 1
    }
}

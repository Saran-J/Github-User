import UIKit

protocol UserReposPresentationLogic {
    func presentUserRepository(response: UserRepos.FetchUserRepository.Response)
    func presentError(error: ServiceError)
}

class UserReposPresenter: UserReposPresentationLogic {
    weak var viewController: UserReposDisplayLogic?
    
    func presentUserRepository(response: UserRepos.FetchUserRepository.Response) {
        let repositoryList: [RepositoryObject] =
            response.userRepository.map { repo -> RepositoryObject in
            let object = RepositoryObject(
                title: toString(repo.name),
                detail: toString(repo.description),
                language: toString(repo.language))
                return object
            }
        let detail = RepositoryDetail(
            name: toString(response.userDetail.login),
            url: toString(response.userDetail.url),
            avatarImageUrl: toString(response.userDetail.avatarUrl),
            isFavorite: toBool(response.userDetail.favorite),
            repository: repositoryList)
        let viewModel = UserRepos.FetchUserRepository.ViewModel(
            repositoryObject: detail,
            isLastPage: response.isLastPage,
            shouldReload: response.shouldReload)
        viewController?.displayUserRepository(viewModel: viewModel)
    }
    
    func presentError(error: ServiceError) {
        viewController?.displayError(
            title: error.getTitle(),
            message: error.getMessage()
        )
    }
}

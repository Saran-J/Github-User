import UIKit
import RxSwift

protocol UserReposBusinessLogic {
    func fetchUserRepository(request: UserRepos.FetchUserRepository.Request)
}

protocol UserReposDataStore {
    var userItem: UserItem? { get set }
}

class UserReposInteractor: UserReposBusinessLogic, UserReposDataStore {
    var perPage: Int = 10
    var page: Int = 1
    var presenter: UserReposPresentationLogic?
    var repositoryService = GetUserRepoService()
    var userItem: UserItem?
    var disposeBag = DisposeBag()
    func fetchUserRepository(request: UserRepos.FetchUserRepository.Request) {
        if request.shouldReload {
            page = 1
        } else {
            page += 1
        }
        repositoryService.executeService(
            user: toString(userItem?.login),
            page: page,
            perPage: perPage
        )
        .subscribe { [weak self] response in
            self?.prepareResponseForPresentUserRepository(
                response,
                shouldReload: request.shouldReload
            )
        } onError: { [weak self] error in
            let serviceError = (error as? ServiceError) ?? ServiceError(.unknownError)
            self?.presenter?.presentError(error: serviceError)
        }
        .disposed(by: disposeBag)
    }
    
    func prepareResponseForPresentUserRepository(
        _ resp: [GetUserRepoResponse],
        shouldReload: Bool
        ) {
        guard let userItem = self.userItem else {
            presenter?.presentError(error: ServiceError(.noData))
            return
        }
        let response = UserRepos.FetchUserRepository.Response(
            userRepository: resp,
            userDetail: userItem,
            isLastPage: resp.count < self.perPage,
            shouldReload: shouldReload
        )
        presenter?.presentUserRepository(response: response)
    }
}

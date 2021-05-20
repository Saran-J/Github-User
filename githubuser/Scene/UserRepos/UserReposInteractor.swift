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
        repositoryService.executeService(
            user: toString(userItem?.login),
            page: page,
            perPage: perPage
        )
        .subscribe { [weak self] response in
            self?.prepareResponseForPresentUserRepository(response)
        } onError: { error in
            print(error)
        }
        .disposed(by: disposeBag)
    }
    
    func prepareResponseForPresentUserRepository(_ resp: [GetUserRepoResponse]) {
        guard let userItem = self.userItem else {
            return
        }
        let response = UserRepos.FetchUserRepository.Response(
            userRepository: resp,
            userDetail: userItem,
            isLastPage: resp.count < self.perPage
        )
        presenter?.presentUserRepository(response: response)
    }
}

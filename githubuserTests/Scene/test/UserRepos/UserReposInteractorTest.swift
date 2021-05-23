import Foundation
import XCTest
@testable import githubuser

class UserReposInteractorTest: XCTestCase {
    override class func setUp() {
        super.setUp()
    }
    
    override class func tearDown() {
        super.tearDown()
    }
    
    func testWhenCallFetchUserRepoSuccessShouldPresentUserRepository() {
        let spyPresenter = UserReposPresenterSpy()
        let stubUserReposService = StubGetUserRepoService(mockResult: .success)
        let interactor = UserReposInteractor()
        interactor.userItem = MockGetUserResponse.getMockWithFavorite()
        interactor.presenter = spyPresenter
        interactor.repositoryService = stubUserReposService
        interactor.fetchUserRepository(
            request: UserRepos.FetchUserRepository.Request(shouldReload: true)
        )
        XCTAssertEqual(1, spyPresenter.countPresentUserRepository)
    }
    
    func testWhenCallFetchUserRepoSuccessButUserItemNullShouldPresentError() {
        let spyPresenter = UserReposPresenterSpy()
        let stubUserReposService = StubGetUserRepoService(mockResult: .success)
        let interactor = UserReposInteractor()
        interactor.presenter = spyPresenter
        interactor.repositoryService = stubUserReposService
        interactor.fetchUserRepository(
            request: UserRepos.FetchUserRepository.Request(shouldReload: true)
        )
        XCTAssertEqual(1, spyPresenter.countPresentError)
    }
    
    func testWhenCallFetchUserRepoFailShouldPresentError() {
        let spyPresenter = UserReposPresenterSpy()
        let stubUserReposService = StubGetUserRepoService(
            mockResult: .failure(error:ServiceError(.translateResponseFail))
        )
        let interactor = UserReposInteractor()
        interactor.presenter = spyPresenter
        interactor.repositoryService = stubUserReposService
        interactor.fetchUserRepository(
            request: UserRepos.FetchUserRepository.Request(shouldReload: true)
        )
        XCTAssertEqual(1, spyPresenter.countPresentError)
    }
}

import Foundation
import XCTest
@testable import githubuser

class UserReposPresenterTest: XCTestCase {
    override class func setUp() {
        super.setUp()
    }
    
    override class func tearDown() {
        super.tearDown()
    }
    
    func testWhenCallPresentUserRepositoryShouldDisplayRepository() {
        let response = UserRepos.FetchUserRepository.Response(
            userRepository: [MockUserReposResponse.getMock()],
            userDetail: MockGetUserResponse.getMockWithFavorite(),
            isLastPage: true,
            shouldReload: true)
        let spy = UserReposViewControllerSpy()
        let presenter = UserReposPresenter()
        presenter.viewController = spy
        presenter.presentUserRepository(response: response)
        XCTAssertEqual(1, spy.countDisplayUserRepository)
    }
    
    func testWhenCallPresentErrorShouldDisplayError() {
        let spy = UserReposViewControllerSpy()
        let presenter = UserReposPresenter()
        presenter.viewController = spy
        presenter.presentError(error: ServiceError(.translateResponseFail))
        XCTAssertEqual(1, spy.countDisplayError)
    }
}

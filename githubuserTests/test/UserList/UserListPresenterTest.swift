import Foundation
import XCTest
@testable import githubuser

class UserListPresenterTest: XCTestCase {
    override class func setUp() {
        super.setUp()
    }
    
    override class func tearDown() {
        super.tearDown()
    }
    
    func testPresentUserListShouldDisplayUserList() {
        let spyViewController = UserListViewControllerSpy()
        let presenter = UserListPresenter()
        presenter.viewController = spyViewController
        let response = UserList.QueryUser.Response(
            searchResponse: MockGetUserResponse.getMockUserList(),
            shouldReload: true,
            isLastPage: true)
        presenter.presentUserList(response: response)
        XCTAssertEqual(1, spyViewController.countDisplayUserList)
    }
    
    func testPresentErrorShouldDisplayError() {
        let spyViewController = UserListViewControllerSpy()
        let presenter = UserListPresenter()
        presenter.viewController = spyViewController
        presenter.presentError(error: ServiceError(.translateResponseFail))
        XCTAssertEqual(1, spyViewController.countDisplayError)
    }
}

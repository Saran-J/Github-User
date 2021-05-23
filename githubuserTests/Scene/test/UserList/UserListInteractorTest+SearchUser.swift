import Foundation
import XCTest
@testable import githubuser

extension UserListInteractorTest {
    func testSearhUserAndSuccessShouldPresentSearchUserList() {
        let spyPresenter = UserListPresenterSpy()
        let interactor = prepareTestSearchUser(mockResult: .success)
        interactor.presenter = spyPresenter
        let request = UserList.QueryUser.Request(
            keyword: "mm",
            shouldReload: true,
            sort: .bestMatch,
            filter: .noFilter
        )
        interactor.queryUserList(request: request)
        XCTAssertEqual(1, spyPresenter.countPresentUserList)
    }
    
    func testSearhUserWithShouldNotReloadAndSuccessShouldPresentSearchUserList() {
        let spyPresenter = UserListPresenterSpy()
        let interactor = prepareTestSearchUser(mockResult: .success)
        interactor.presenter = spyPresenter
        let request = UserList.QueryUser.Request(
            keyword: "mm",
            shouldReload: false,
            sort: .bestMatch,
            filter: .noFilter
        )
        interactor.queryUserList(request: request)
        XCTAssertEqual(1, spyPresenter.countPresentUserList)
    }
    
    func testSearchUserAndFailWithServiceErrorShouldPresentError() {
        let spyPresenter = UserListPresenterSpy()
        let interactor = prepareTestSearchUser(
            mockResult: .failure(error: ServiceError(.translateResponseFail)))
        interactor.presenter = spyPresenter
        let request = UserList.QueryUser.Request(
            keyword: "mm",
            shouldReload: true,
            sort: .bestMatch,
            filter: .noFilter
        )
        interactor.queryUserList(request: request)
        XCTAssertEqual(1, spyPresenter.countPresentError)
    }
    
    func testSearchUserAndFailFailWhichIsNotServiceErrorShouldStillPresentError() {
        let spyPresenter = UserListPresenterSpy()
        let interactor = prepareTestSearchUser(
            mockResult: .failureUnknowError(error: .unknowError))
        interactor.presenter = spyPresenter
        let request = UserList.QueryUser.Request(
            keyword: "mm",
            shouldReload: true,
            sort: .bestMatch,
            filter: .noFilter
        )
        interactor.queryUserList(request: request)
        XCTAssertEqual(1, spyPresenter.countPresentError)
    }
}

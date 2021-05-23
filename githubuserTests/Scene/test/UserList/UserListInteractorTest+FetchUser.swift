import Foundation
import XCTest
@testable import githubuser

extension UserListInteractorTest {
    func testFetchUserAndSuccessSholudPresentUserList() {
        let spyPresenter = UserListPresenterSpy()
        let interactor = prepareTestFetchUser(mockResult: .success)
        interactor.presenter = spyPresenter
        let requset = UserList.QueryUser.Request(
            keyword: "",
            shouldReload: true,
            sort: .bestMatch,
            filter: .noFilter
        )
        interactor.queryUserList(request: requset)
        XCTAssertEqual(1, spyPresenter.countPresentUserList)
    }
    
    func testFetchUserAndFailSholudPresentError() {
        let spyPresenter = UserListPresenterSpy()
        let interactor = prepareTestFetchUser(
            mockResult: .failure(error: ServiceError(.translateResponseFail))
        )
        interactor.presenter = spyPresenter
        let requset = UserList.QueryUser.Request(
            keyword: "",
            shouldReload: true,
            sort: .bestMatch,
            filter: .noFilter
        )
        interactor.queryUserList(request: requset)
        XCTAssertEqual(1, spyPresenter.countPresentError)
    }
    
    func testFetchUserAndFailWhichIsNotServiceErrorSholudStillPresentError() {
        let spyPresenter = UserListPresenterSpy()
        let interactor = prepareTestFetchUser(
            mockResult: .failureUnknowError(error: .unknowError)
        )
        interactor.presenter = spyPresenter
        let requset = UserList.QueryUser.Request(
            keyword: "",
            shouldReload: true,
            sort: .bestMatch,
            filter: .noFilter
        )
        interactor.queryUserList(request: requset)
        XCTAssertEqual(1, spyPresenter.countPresentError)
    }
}

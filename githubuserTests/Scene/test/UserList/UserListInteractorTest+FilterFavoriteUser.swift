import Foundation
import XCTest
@testable import githubuser

extension UserListInteractorTest {
    func testFilterFavoriteAndSuccessShouldPresentUserList() {
        let spyPresenter = UserListPresenterSpy()
        let interactor = prepareTestShowFavoriteUser(mockResult: .success)
        interactor.presenter = spyPresenter
        let request = UserList.QueryUser.Request(
            keyword: "",
            shouldReload: true,
            sort: .bestMatch,
            filter: .favorite)
        interactor.queryUserList(request: request)
        XCTAssertEqual(1, spyPresenter.countPresentUserList)
    }
    
    func testFilterFavoriteWithShouldNotReloadAndSuccessShouldPresentUserList() {
        let spyPresenter = UserListPresenterSpy()
        let interactor = prepareTestShowFavoriteUser(mockResult: .success)
        interactor.presenter = spyPresenter
        let request = UserList.QueryUser.Request(
            keyword: "",
            shouldReload: false,
            sort: .bestMatch,
            filter: .favorite)
        interactor.queryUserList(request: request)
        XCTAssertEqual(1, spyPresenter.countPresentUserList)
    }
    
    func testFilterFavoriteAndSuccessWithNoRecordShouldStillPresentUserList() {
        let spyPresenter = UserListPresenterSpy()
        let interactor = prepareTestShowEmptyFavoriteUser(mockResult: .success)
        interactor.presenter = spyPresenter
        let request = UserList.QueryUser.Request(
            keyword: "",
            shouldReload: true,
            sort: .bestMatch,
            filter: .favorite)
        interactor.queryUserList(request: request)
        XCTAssertEqual(1, spyPresenter.countPresentUserList)
    }
    
    func testFilterFavoriteAndFailWithServiceErrorShouldPresentError() {
        let spyPresenter = UserListPresenterSpy()
        let interactor = prepareTestShowFavoriteUser(
            mockResult: .failure(error: ServiceError(.translateResponseFail)))
        interactor.presenter = spyPresenter
        let request = UserList.QueryUser.Request(
            keyword: "",
            shouldReload: true,
            sort: .bestMatch,
            filter: .favorite)
        interactor.queryUserList(request: request)
        XCTAssertEqual(1, spyPresenter.countPresentError)
    }
    
    func testFilterFavoriteAndFailWhichIsNotServiceErrorShouldStillPresentError() {
        let spyPresenter = UserListPresenterSpy()
        let interactor = prepareTestShowFavoriteUser(
            mockResult: .failureUnknowError(error: .unknowError))
        interactor.presenter = spyPresenter
        let request = UserList.QueryUser.Request(
            keyword: "",
            shouldReload: true,
            sort: .bestMatch,
            filter: .favorite)
        interactor.queryUserList(request: request)
        XCTAssertEqual(1, spyPresenter.countPresentError)
    }
}

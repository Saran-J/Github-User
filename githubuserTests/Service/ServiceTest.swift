import Foundation
import XCTest
import RxSwift
@testable import githubuser

class GitHubUserServiceTest: XCTestCase {
    let disposeBag = DisposeBag()
    func testGetUserListWhenSuccessShouldMapToResponse() {
        let expectation = XCTestExpectation(description: "FetchUserList")
        let service = GetUserService(unitTest: true)
        service.executeService(lastUserId: 1, perPage: 1)
        .bind { _ in
            expectation.fulfill()
        }
        .disposed(by: disposeBag)
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testGetUserListWhenFailShuldThrowTranslateResponse() {
        let expectation = XCTestExpectation(description: "FetchUserListError")
        let service = GetUserService(unitTest: true)
        service.executeService(lastUserId: 2, perPage: 1)
        .subscribe(onError: { error in
            if let serviceError = error as? ServiceError,
            serviceError.type == .translateResponseFail {
                expectation.fulfill()
            }
        })
        .disposed(by: disposeBag)
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testSearchUserListWhenSuccessShouldMapToResponse() {
        let expectation = XCTestExpectation(description: "SearchUserList")
        let service = SearchUserService(unitTest: true)
        service.executeService(
            keyword: "success",
            sort: .bestMatch,
            page: 1,
            perPage: 1)
        .bind { _ in
            expectation.fulfill()
        }
        .disposed(by: disposeBag)
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testSearchUserListWhenFailShouldThrowTranslateResponse() {
        let expectation = XCTestExpectation(description: "FetchUserListError")
        let service = SearchUserService(unitTest: true)
        service.executeService(
            keyword: "failure",
            sort: .bestMatch,
            page: 1,
            perPage: 1)
        .subscribe(onError: { error in
            if let serviceError = error as? ServiceError,
            serviceError.type == .translateResponseFail {
                expectation.fulfill()
            }
        })
        .disposed(by: disposeBag)
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testGetUserReposWhenSuccessShouldMapToResponse() {
        let expectation = XCTestExpectation(description: "GetUserRepos")
        let service = GetUserRepoService(unitTest: true)
        service.executeService(
            user: "success",
            page: 1,
            perPage: 1
        )
        .bind { _ in
            expectation.fulfill()
        }
        .disposed(by: disposeBag)
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testGetUserReposWhenFailShuldThrowTranslateResponse() {
        let expectation = XCTestExpectation(description: "GetUserReposError")
        let service = GetUserRepoService(unitTest: true)
        service.executeService(
            user: "failure",
            page: 1,
            perPage: 1
        )
        .subscribe(onError: { error in
            if let serviceError = error as? ServiceError,
            serviceError.type == .translateResponseFail {
                expectation.fulfill()
            }
        })
        .disposed(by: disposeBag)
        wait(for: [expectation], timeout: 2.0)
    }
}

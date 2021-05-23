import Foundation
import XCTest
@testable import githubuser

class UserListInteractorTest: XCTestCase {
    override class func setUp() {
        super.setUp()
    }
    
    override class func tearDown() {
        super.tearDown()
    }
    
    func prepareTestFetchUser(mockResult: MockResult) -> UserListInteractor {
        let stubGetUserListService = StubGetUserService(mockResult: mockResult)
        let stubCoreData = StubCoreData()
        let getUserWorker = FetchUserWorker()
        getUserWorker.userListService = stubGetUserListService
        let favoriteWorker = FavoriteWorker()
        favoriteWorker.coreDataWorker = stubCoreData
        let interactor = UserListInteractor()
        interactor.fetchUserWorker = getUserWorker
        interactor.favoriteWorker = favoriteWorker
        return interactor
    }
    
    func prepareTestSearchUser(mockResult: MockResult) -> UserListInteractor {
        let stubSearchUserService = StubSearchUserService(mockResult: mockResult)
        let stubCoreData = StubCoreData()
        let searchUserWorker = SearchWorker()
        searchUserWorker.searchUserService = stubSearchUserService
        let favoriteWorker = FavoriteWorker()
        favoriteWorker.coreDataWorker = stubCoreData
        let interactor = UserListInteractor()
        interactor.searchWorker = searchUserWorker
        interactor.favoriteWorker = favoriteWorker
        return interactor
    }
    
    func prepareTestShowFavoriteUser(mockResult: MockResult) -> UserListInteractor {
        let stubSearchUserService = StubSearchUserService(mockResult: mockResult)
        let stubCoreData = StubCoreData()
        let searchUserWorker = SearchWorker()
        searchUserWorker.searchUserService = stubSearchUserService
        let favoriteWorker = FavoriteWorker()
        favoriteWorker.searchUserService = stubSearchUserService
        favoriteWorker.coreDataWorker = stubCoreData
        let interactor = UserListInteractor()
        interactor.searchWorker = searchUserWorker
        interactor.favoriteWorker = favoriteWorker
        return interactor
    }
    
    func prepareTestShowEmptyFavoriteUser(mockResult: MockResult) -> UserListInteractor {
        let stubSearchUserService = StubSearchUserService(mockResult: mockResult)
        let stubCoreData = StubCoreData(hasFavorite: false)
        let searchUserWorker = SearchWorker()
        searchUserWorker.searchUserService = stubSearchUserService
        let favoriteWorker = FavoriteWorker()
        favoriteWorker.searchUserService = stubSearchUserService
        favoriteWorker.coreDataWorker = stubCoreData
        let interactor = UserListInteractor()
        interactor.searchWorker = searchUserWorker
        interactor.favoriteWorker = favoriteWorker
        return interactor
    }
}

import Foundation
import RxSwift
@testable import githubuser

class StubCoreData: CoreDataWorker {
    let hasFavorite: Bool
    public init (hasFavorite: Bool = true) {
        self.hasFavorite = hasFavorite
    }
    override func makeFavorite(userId: Int64, uesrName: String) {
    }
    
    override func makeUnFavorite(userId: Int64) {
    }
    
    override func fetchFavorite(keyword: String = "", startIndex: Int = 0, pagination: Bool) -> Observable<[UserFavoriteModel]> {
        if hasFavorite {
            let mockUser = MockGetUserResponse.getMockWithFavorite()
            let model = UserFavoriteModel(
                id: Int64(toInt(mockUser.id)),
                name: toString(mockUser.login)
            )
            return .just([model])
        } else {
            return .just([])
        }
    }
}

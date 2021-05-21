import Foundation
import RxSwift

struct SearchUserResponse: Codable {
    var totalCount: Int
    var incompleteResults: Bool
    var items: [UserItem]
    
    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case incompleteResults = "incomplete_results"
        case items = "items"
    }
}

class SearchUserService: BaseService<UserProvider, SearchUserResponse> {
    func executeService(keyword: String, sort: SortData, page: Int, perPage: Int) -> Observable<SearchUserResponse> {
        return super.callService(
            target: UserProvider.searchUser(
                keyword: keyword,
                sort: sort,
                page: page,
                perPage: perPage
            )
        )
    }
}

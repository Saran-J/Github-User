import Foundation
import Moya

enum UserProvider {
    case fetchUser(lastUserId: Int, perPage: Int)
    case searchUser(keyword: String, sort: SortData, page: Int, perPage: Int)
    case fetchUserRepo(user: String, page: Int, perPage: Int)
}

extension UserProvider: TargetType {
    var baseURL: URL {
        return URL(string: "https://api.github.com") ?? URL(fileURLWithPath: "")
    }
    
    var path: String {
        switch self {
        case .fetchUser:
            return "/users"
        case .searchUser:
            return "/search/users"
        case .fetchUserRepo (let user, _, _):
            return "users/\(user)/repos"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .fetchUser:
            return .get
        case .searchUser:
            return .get
        case .fetchUserRepo:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case let .fetchUser(lastUserId, perPage):
            return .requestParameters(
                parameters: ["since": lastUserId, "per_page": perPage],
                encoding: URLEncoding.queryString)
        case let .searchUser(keyword, sort, page, perPage):
            return .requestParameters(
                parameters: [
                    "q": keyword.isEmpty ? "\"\"" : keyword,
                    "o": sort.orderQueryString(),
                    "sort": sort.queryString(),
                    "page": page,
                    "per_page": perPage
                ],
                encoding: URLEncoding.queryString)
        case let .fetchUserRepo(_, page, perPage):
            return .requestParameters(
                parameters: [
                    "page": page,
                    "per_page": perPage
                ],
                encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String: String]? {
        return ["Content-type": "application/json"]
    }
    
    var sampleData: Data {
        switch self {
        case .fetchUser(let lastId, _):
            if lastId != 1 {
                return "fail value".data(using: .utf8) ?? Data.init()
            }
            return ProviderTestData.userListData.data(using: .utf8) ?? Data.init()
        case .searchUser(let keyword, _, _, _):
            if keyword != "success" {
                return "fail value".data(using: .utf8) ?? Data.init()
            }
            return ProviderTestData.searchUserData.data(using: .utf8) ?? Data.init()
        case .fetchUserRepo(let user, _, _):
            if user != "success" {
                return "fail value".data(using: .utf8) ?? Data.init()
            }
            return ProviderTestData.userReposData.data(using: .utf8) ?? Data.init()
        }
    }
}

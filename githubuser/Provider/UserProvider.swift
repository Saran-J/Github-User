import Foundation
import Moya

enum UserProvider {
    case fetchUser(page: Int, perPage: Int)
    case searchUser
    case fetchUserRepo(user: String)
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
        case .fetchUserRepo (let user):
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
        case let .fetchUser(page, perPage):
            return .requestParameters(
                parameters: ["since": page, "perPage": perPage],
                encoding: URLEncoding.queryString)
        case .searchUser:
            return .requestPlain
        case .fetchUserRepo:
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        return ["Content-type": "application/json"]
    }
    
    var sampleData: Data {
        return "".data(using: .utf8) ?? Data.init()
    }
}

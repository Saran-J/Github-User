import UIKit

enum UserList {
    enum FetchUserList {
        struct Request {
            var shouldReload: Bool
        }
        struct Response {
            var userListRespnse: [UserItem]
            var shouldReload: Bool
        }
        struct ViewModel {
            var userListDisplay: [UserListObject]
            var shouldReload: Bool
        }
    }
    
    enum SearchUser {
        struct Request {
            var keyword: String
            var shouldReload: Bool
        }
        struct Response {
            var searchResponse: SearchUserResponse
            var shouldReload: Bool
        }
        struct ViewModel {
            var userListDisplay: [UserListObject]
            var shouldReload: Bool
        }
    }
}

struct UserListObject {
    var name: String
    var url: String
    var avatarImageUrl: String
}

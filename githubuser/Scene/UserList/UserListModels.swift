import UIKit

enum UserList {
    enum FetchUserList {
        struct Request {}
        struct Response {
            var userListRespnse: [UserItem]
        }
        struct ViewModel {
            var userListDisplay: [UserListObject]
        }
    }
    
    enum SearchUser {
        struct Request {
            var keyword: String
        }
        struct Response {
            var searchResponse: SearchUserResponse
        }
        struct ViewModel {
            var userListDisplay: [UserListObject]
        }
    }
}

struct UserListObject {
    var name: String
    var url: String
    var avatarImageUrl: String
}

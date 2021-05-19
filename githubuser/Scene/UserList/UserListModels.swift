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
            var searchResponse: [UserItem]
            var shouldReload: Bool
        }
        struct ViewModel {
            var userListDisplay: [UserListObject]
            var shouldReload: Bool
        }
    }
    
    enum FavoriteUser {
        struct Request {
            var userId: Int
            var favorite: Bool
        }
    }
}

struct UserListObject {
    var id: Int64
    var name: String
    var url: String
    var avatarImageUrl: String
    var isFavorite: Bool
}

import UIKit

enum UserList {
    enum QueryUser {
        struct Request {
            var keyword: String
            var shouldReload: Bool
            var sort: SortData
            var filter: FilterData
        }
        struct Response {
            var searchResponse: [UserItem]
            var shouldReload: Bool
            var isLastPage: Bool
        }
        struct ViewModel {
            var userListDisplay: [UserListObject]
            var shouldReload: Bool
            var isLastPage: Bool
        }
    }
    
    enum FavoriteUser {
        struct Request {
            var userId: Int64
            var userName: String
            var favorite: Bool
        }
    }
}

class UserListObject {
    var id: Int64
    var name: String
    var url: String
    var avatarImageUrl: String
    var isFavorite: Bool

    init(
        id: Int64,
        name: String,
        url: String,
        avatarImageUrl: String,
        isFavorite: Bool
    ) {
        self.id = id
        self.name = name
        self.url = url
        self.avatarImageUrl = avatarImageUrl
        self.isFavorite = isFavorite
    }
}

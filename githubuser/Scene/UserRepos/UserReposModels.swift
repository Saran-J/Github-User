import UIKit
enum UserRepos {
    enum FetchUserRepository {
        struct Request {
            var user: String
        }
        struct Response {
            var userRepository: [GetUserRepoResponse]
            var userDetail: UserItem
            var isLastPage: Bool
        }
        struct ViewModel {
            var repositoryObject: RepositoryDetail
        }
    }
}

struct RepositoryDetail {
    var name: String
    var url: String
    var avatarImageUrl: String
    var isFavorite: Bool
    var repository: [RepositoryObject]
}

struct RepositoryObject {
    var title: String
    var detail: String
    var language: String
}

import Foundation
@testable import githubuser

class MockGetUserResponse: NSObject {
    static func getMockUserList() -> [UserItem] {
        return [getMockWithNoFavorite(), getMockWithFavorite()]
    }
    static func getMockWithNoFavorite() -> UserItem {
        let mock = UserItem(
            login: "octocat",
            id: 583231,
            nodeId: "MDQ6VXNlcjU4MzIzMQ==",
            avatarUrl: "https://avatars.githubusercontent.com/u/583231?v=4",
            gravatarId: "",
            url: "https://api.github.com/users/octocat",
            htmlUrl: "https://github.com/octocat",
            followersUrl: "https://api.github.com/users/octocat/followers",
            followingUrl: "https://api.github.com/users/octocat/following{/other_user}",
            gistsUrl: "https://api.github.com/users/octocat/gists{/gist_id}",
            starredUrl: "https://api.github.com/users/octocat/starred{/owner}{/repo}",
            subscriptionsUrl: "https://api.github.com/users/octocat/subscriptions",
            organizationsUrl: "https://api.github.com/users/octocat/orgs",
            reposUrl: "https://api.github.com/users/octocat/repos",
            eventsUrl: "https://api.github.com/users/octocat/events{/privacy}",
            receivedEventsUrl: "https://api.github.com/users/octocat/received_events",
            type: "User",
            siteAdmin: false,
            favorite: false
        )
        return mock
    }
    
    static func getMockWithFavorite() -> UserItem {
        let mock = UserItem(
            login: "octocat",
            id: 583231,
            nodeId: "MDQ6VXNlcjU4MzIzMQ==",
            avatarUrl: "https://avatars.githubusercontent.com/u/583231?v=4",
            gravatarId: "",
            url: "https://api.github.com/users/octocat",
            htmlUrl: "https://github.com/octocat",
            followersUrl: "https://api.github.com/users/octocat/followers",
            followingUrl: "https://api.github.com/users/octocat/following{/other_user}",
            gistsUrl: "https://api.github.com/users/octocat/gists{/gist_id}",
            starredUrl: "https://api.github.com/users/octocat/starred{/owner}{/repo}",
            subscriptionsUrl: "https://api.github.com/users/octocat/subscriptions",
            organizationsUrl: "https://api.github.com/users/octocat/orgs",
            reposUrl: "https://api.github.com/users/octocat/repos",
            eventsUrl: "https://api.github.com/users/octocat/events{/privacy}",
            receivedEventsUrl: "https://api.github.com/users/octocat/received_events",
            type: "User",
            siteAdmin: false,
            favorite: true
        )
        return mock
    }
}

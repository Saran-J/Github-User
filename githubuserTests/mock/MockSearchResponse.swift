import Foundation
@testable import githubuser

class MockSearchResponse: NSObject {
    static func getMock() -> SearchUserResponse {
        let mock = SearchUserResponse(
            totalCount: 2,
            incompleteResults: false,
            items: MockGetUserResponse.getMockUserList())
        return mock
    }
}

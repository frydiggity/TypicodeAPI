import Dependencies
import DependenciesMacros
import Foundation
import Models

@DependencyClient
public struct NetworkClient: Sendable {
    public var loadUsers: @Sendable () async throws -> [User]
    public var loadPosts: @Sendable () async throws -> [Post]
    
    public enum NetworkFetchError: Error {
        case networkError
    }
}

extension NetworkClient: DependencyKey {
    public static var liveValue: NetworkClient {

        // While not exercised in this example, this @Dependency allows us to inject a specifically configured or
        // mocked URLSession instance into this client to be able to return mocked data without making network
        // calls and still be able to test the JSON Deserialization independently
        @Dependency(\.urlSession) var urlSession
        
        // If there are business rules for how to specifically decode API responses from a particular API (i.e.
        // date encoding/parsing configurations) then a single configured JSONDecoder instance could be similarly
        // injected as a @Dependency here as well
         @Dependency(\.typicodeJSONDecoder) var jsonDecoder
                
        return Self(
            loadUsers: {
                let (data, response) = try await urlSession.data(from: .usersURL)
                guard let response = response as? HTTPURLResponse, response.isInOKRange else {
                    // Log error
                    // Likely way more logic here for a more sophisticated use case
                    throw NetworkFetchError.networkError
                }
                
                let users = try jsonDecoder().decode([User].self, from: data)
                return users
            },
            loadPosts: {
                let (data, response) = try await urlSession.data(from: .postsURL)
                guard let response = response as? HTTPURLResponse, response.isInOKRange else {
                    // Log error
                    // Likely way more logic here for a more sophisticated use case
                    throw NetworkFetchError.networkError
                }
                let posts = try jsonDecoder().decode([Post].self, from: data)
                return posts
            }
        )
    }
    
    public static let previewValue = NetworkClient(
        loadUsers: { .mocks },
        loadPosts: { .mocks }
    )
    
    public static let slowLoadingMocks = NetworkClient(
        loadUsers: {
            try await Task.sleep(nanoseconds: 3 * NSEC_PER_SEC)
            return .mocks
        },
        loadPosts: {
            try await Task.sleep(nanoseconds: 3 * NSEC_PER_SEC)
            return .mocks
        }
    )
}

public extension DependencyValues {
    var networkClient: NetworkClient {
        get { self[NetworkClient.self] }
        set { self[NetworkClient.self] = newValue }
    }
}

private extension HTTPURLResponse {
    var isInOKRange: Bool {
        (200...299).contains(self.statusCode)
    }
}

extension URL {
    static let usersURL = URL(string: "https://jsonplaceholder.typicode.com/users")!
    static let postsURL = URL(string: "https://jsonplaceholder.typicode.com/posts")!
}

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
                guard let response = response as? HTTPURLResponse, response.isResponseOK else {
                    // Log error
                    // Likely way more logic here for a more sophisticated use case
                    throw NetworkFetchError.networkError
                }
                
                let users = try jsonDecoder().decode([User].self, from: data)
                return users
            },
            loadPosts: {
                let (data, response) = try await urlSession.data(from: .postsURL)
                guard let response = response as? HTTPURLResponse, response.isResponseOK else {
                    // Log error
                    // Likely way more logic here for a more sophisticated use case
                    throw NetworkFetchError.networkError
                }
                let posts = try jsonDecoder().decode([Post].self, from: data)
                return posts
            }
        )
    }
        
    // DependencyClient macro creates a test version that throws unimplemented errors for each endpoint
    // Endpoints should be overridden explicitly in tests
    public static let testValue = Self()
}

extension HTTPURLResponse {
    var isResponseOK: Bool {
        (200...299).contains(self.statusCode)
    }
}


public extension DependencyValues {
  var networkClient: NetworkClient {
    get { self[NetworkClient.self] }
    set { self[NetworkClient.self] = newValue }
  }
}

extension URL {
    static let usersURL = URL(string: "https://jsonplaceholder.typicode.com/users")!
    static let postsURL = URL(string: "https://jsonplaceholder.typicode.com/posts")!
}

#if DEBUG

package extension Array where Element == User {
    static let mocks: [User] = [
        .init(
            id: 5,
            name: "Jenny Graham",
            username: "Jenny",
            email: "Sincere@april.biz",
            address: .init(street: "1st Street", city: "Anytown", zipcode: "12345", geo: .init(lat: "99.0", lng: "-123.45")),
            phone: "+1-555-867-5309",
            website: "https://giggle.com",
            company: .init(name: "Acme", catchPhrase: "We almost get roadrunners", bs: "Roadrunner gone or you go boom")
        ),
        .init(
            id: 6,
            name: "Erwin Smith",
            username: "Erwin",
            email: "Erwin.Smith@gmail.com",
            address: .init(street: "2nd Street", city: "Anytown", zipcode: "12345", geo: .init(lat: "99.0", lng: "-123.45")),
            phone: "+1-555-555-5555",
            website: "https://gaggle.com",
            company: .init(name: "Acme", catchPhrase: "We almost get roadrunners", bs: "Roadrunner gone or you go boom")
        ),
    ]
}

package extension Array where Element == Post {
    static let mocks: [Post] = [
        .init(id: 10, userId: 5, title: "First post title", body: "First post body"),
        .init(id: 11, userId: 6, title: "Second post title", body: "Second post body"),
        .init(id: 12, userId: 5, title: "Third post title", body: "Thirs post body"),
    ]
}

#endif

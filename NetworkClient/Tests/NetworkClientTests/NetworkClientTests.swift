import Dependencies
import Foundation
import Models
import NetworkClient
import Testing

// These live tests should not be in the regular suite of Unit Tests because they make actual network calls.
// However, since the APIs we're using return static, consistent content, they do provide some utility to
// quickly sanity-check...sort of a low-fi End-To-End test. Using a tag here to enable creation of test plans
// that exclude (or include) these types of tests

extension Tag {
    @Tag static var liveNetwork: Self
}

@Suite("NetworkClient tests", .serialized)
struct NetworkClientTests {
    
    @Suite("Fetch Users tests", .serialized)
    class FetchUsersTests {
        
        @Test("Fetch Users - Live Client", .tags(.liveNetwork))
        func LiveClientFetchUsers() async throws {
            let client = withDependencies {
                $0.urlSession = .shared
            } operation: {
                NetworkClient.liveValue
            }
            
            let users = try await client.loadUsers()
            #expect(users.count == 10)
            #expect(users.first?.name == "Leanne Graham")
        }

        @Test("Fetch Users - URLSession failure")
        func URLSessionFailureFetchUsers() async throws {
            struct MockNetworkError: Error {}
            
            let mockConfiguration = URLSessionConfiguration.ephemeral
            mockConfiguration.protocolClasses = [MockURLProtocol.self]
            MockURLProtocol.requestHandler = { _ in
                throw MockNetworkError()
            }
            
            let client = withDependencies {
                $0.urlSession = URLSession(configuration: mockConfiguration)
            } operation: {
                NetworkClient.liveValue
            }
            
            do {
                let _ = try await client.loadUsers()
            } catch {
                #expect(error.localizedDescription.contains("MockNetworkError"))
            }
        }
 
        @Test("Fetch Users - Server Failure response")
        func ServerFailureFetchUsers() async throws {
            struct MockNetworkError: Error {}
            
            let mockConfiguration = URLSessionConfiguration.ephemeral
            mockConfiguration.protocolClasses = [MockURLProtocol.self]
            MockURLProtocol.requestHandler = { request in
                let response = HTTPURLResponse(
                    url: request.url!,
                    statusCode: 500,
                    httpVersion: nil,
                    headerFields: nil
                )!
                return (response, Data())
            }
            
            let client = withDependencies {
                $0.urlSession = URLSession(configuration: mockConfiguration)
            } operation: {
                NetworkClient.liveValue
            }
            
            await #expect(throws: NetworkClient.NetworkFetchError.self) {
                let _ = try await client.loadUsers()
            }
        }

        @Test("Fetch Users - Mock Data Deserializes")
        func MockDataFetchUsers() async throws {
            let mockUsers = [User].mocks
            let mocksData = try JSONEncoder().encode(mockUsers)
            
            let mockConfiguration = URLSessionConfiguration.ephemeral
            mockConfiguration.protocolClasses = [MockURLProtocol.self]
            MockURLProtocol.requestHandler = { request in
                let response = HTTPURLResponse(
                    url: request.url!,
                    statusCode: 200,
                    httpVersion: nil,
                    headerFields: nil
                )!
                return (response, mocksData)
            }
            
            let client = withDependencies {
                $0.urlSession = URLSession(configuration: mockConfiguration)
            } operation: {
                NetworkClient.liveValue
            }
            
            let users = try await client.loadUsers()
            #expect(users == mockUsers)
        }

        deinit {
            // reset requestHandler after tests
            MockURLProtocol.requestHandler = nil
        }
    }
    
    @Suite("Fetch Posts tests", .serialized)
    class FetchPostsTests {
        
        @Test("Fetch Posts - Live Client", .tags(.liveNetwork))
        func LiveClientFetchPosts() async throws {
            let client = withDependencies {
                $0.urlSession = .shared
            } operation: {
                NetworkClient.liveValue
            }
            
            let posts = try await client.loadPosts()
            #expect(posts.count == 100)
            #expect(posts.first?.title == "sunt aut facere repellat provident occaecati excepturi optio reprehenderit")
        }
        
        @Test("Fetch Posts - URLSession failure")
        func URLSessionFailureFetchPosts() async throws {
            struct MockNetworkError: Error {}
            
            let mockConfiguration = URLSessionConfiguration.ephemeral
            mockConfiguration.protocolClasses = [MockURLProtocol.self]
            MockURLProtocol.requestHandler = { _ in
                throw MockNetworkError()
            }
            
            let client = withDependencies {
                $0.urlSession = URLSession(configuration: mockConfiguration)
            } operation: {
                NetworkClient.liveValue
            }
            
            do {
                let _ = try await client.loadPosts()
            } catch {
                #expect(error.localizedDescription.contains("MockNetworkError"))
            }
        }
        
        @Test("Fetch Posts - Server Failure response")
        func ServerFailureFetchPosts() async throws {
            struct MockNetworkError: Error {}
            
            let mockConfiguration = URLSessionConfiguration.ephemeral
            mockConfiguration.protocolClasses = [MockURLProtocol.self]
            MockURLProtocol.requestHandler = { request in
                let response = HTTPURLResponse(
                    url: request.url!,
                    statusCode: 500,
                    httpVersion: nil,
                    headerFields: nil
                )!
                return (response, Data())
            }
            
            let client = withDependencies {
                $0.urlSession = URLSession(configuration: mockConfiguration)
            } operation: {
                NetworkClient.liveValue
            }
            
            await #expect(throws: NetworkClient.NetworkFetchError.self) {
                let _ = try await client.loadPosts()
            }
        }

        @Test("Fetch Posts - Mock Data Deserializes")
        func MockDataFetchPosts() async throws {
            let mockPosts = [Post].mocks
            let mocksdata = try JSONEncoder().encode(mockPosts)
            
            let mockConfiguration = URLSessionConfiguration.ephemeral
            mockConfiguration.protocolClasses = [MockURLProtocol.self]
            MockURLProtocol.requestHandler = { request in
                let response = HTTPURLResponse(
                    url: request.url!,
                    statusCode: 200,
                    httpVersion: nil,
                    headerFields: nil
                )!
                return (response, mocksdata)
            }
            
            let client = withDependencies {
                $0.urlSession = URLSession(configuration: mockConfiguration)
            } operation: {
                NetworkClient.liveValue
            }
            
            let posts = try await client.loadPosts()
            #expect(posts == mockPosts)
        }

        deinit {
            // reset requestHandler after tests
            MockURLProtocol.requestHandler = nil
        }
    }
    
}

// MARK: - MockURLProtocol

class MockURLProtocol: URLProtocol {
    override class func canInit(with request: URLRequest) -> Bool {
        true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }
    
    // This global shared state where otherwise-parallelized tests are setting this static handler
    // means we need to instead run the test suites with the .serialized trait. Doing this in a
    // more Thread-safe way would be a future refactor.
    nonisolated(unsafe) static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data))?
    
    override func startLoading() {
        guard let handler = MockURLProtocol.requestHandler else {
            XCTFail("No request handler provided")
            return
        }
        
        do {
            let (response, data) = try handler(request)
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
            client?.urlProtocolDidFinishLoading(self)
        }
    }
    
    override func stopLoading() {}
}

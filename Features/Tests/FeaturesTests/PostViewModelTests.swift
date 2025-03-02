import Dependencies
import Models
import NetworkClient
import Tagged
import Testing
@testable import Features

@Suite("Posts ViewModel Tests")
struct PostsViewModelTests {
    
    @Test("load Fetches users")
    func loadUsers() async throws {
        let viewModel = withDependencies {
            $0.networkClient = NetworkClient.previewValue
        } operation: {
            PostsViewModel()
        }
        
        #expect(viewModel.users == [:])
        
        await viewModel.load()
        
        #expect(viewModel.users.count == 2)
        #expect(viewModel.users[5]?.name == "Steve Erwin")
        #expect(viewModel.users[6]?.name == "Al Yankovich")
    }
  
    @Test("load Fetches posts")
    func loadPosts() async throws {
        let viewModel = withDependencies {
            $0.networkClient = NetworkClient.previewValue
        } operation: {
            PostsViewModel()
        }
        
        #expect(viewModel.state == .loading)
        
        await viewModel.load()
        
        #expect(viewModel.state == .loaded([Post].mocks))
    }
}

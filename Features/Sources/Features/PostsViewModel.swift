import Dependencies
import Models
import Perception

@Perceptible
public class PostsViewModel: @unchecked Sendable {
    
    // MARK: - Nested Types
    
    public enum State: Equatable {
        case loading
        case loaded([Post])
        case error(ErrorState)
    }
    
    public struct ErrorState: Equatable {
        let title: String
        let description: String
        
        public init(title: String, description: String) {
            self.title = title
            self.description = description
        }
    }
    
    // MARK: Properties
    
    var state: State
    
    @PerceptionIgnored
    var users: [User.ID: User] = [:]
    
    @PerceptionIgnored
    @Dependency(\.networkClient)
    var client

    // MARK: - Initializer
    
    public init(state: State = .loading) {
        self.state = state
    }
    
    // MARK: - Methods
    
    func load() async {
        do {
            // Load posts and users in parallel
            async let postsFetch = client.loadPosts()
            async let usersFetch = client.loadUsers()
            let (posts, users) = try await(postsFetch, usersFetch)
 
            // Create a dictionary of users for easy lookup by id
            // Assumption: All Users returned from API have unique .id values
            self.users = Dictionary(uniqueKeysWithValues: zip(users.map(\.id), users))
            
            // While not technically an error, piggy-back on .error state when no posts
            if posts.isEmpty {
                state = .error(
                    .init(
                        title: "No Posts",
                        description: #""Uh, everything's under control. Situation normal. How are you?"\n\n- Han Solo"#
                    )
                )
            } else {
                state = .loaded(posts)
            }
        } catch {
            state = .error(
                .init(
                    title: "Error Loading Posts",
                    description: "Maybe go drive around the block and try again."
                )
            )
        }
    }
}


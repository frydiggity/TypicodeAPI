import Foundation
import Tagged

public struct Post: Hashable, Identifiable, Sendable, Codable {
    
    // MARK: - Typealias
    
    public typealias ID = Tagged<Post, Int>
    
    // MARK: - Public Properties
    
    public let id: Post.ID
    public let userId: User.ID
    public let title: String
    public let body: String
    
    // MARK: - Initializers

    public init(
        id: Tagged<Post, Int>,
        userId: Tagged<User, Int>,
        title: String,
        body: String
    ) {
        self.id = id
        self.userId = userId
        self.title = title
        self.body = body
    }
}

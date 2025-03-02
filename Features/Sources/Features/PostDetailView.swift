import Models
import SwiftUI

// MARK: PostDetail View

public struct PostDetailView: View {

    let post: Post
    let user: User?
    
    public init(post: Post, user: User?) {
        self.post = post
        self.user = user
    }
    
    public var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text(post.title)
                    .font(.title)
                    .bold()
                Text(post.body)
                    .padding(.horizontal)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .overlay(alignment: .bottomTrailing) {
            if let user {
                UserBugView(user: user)
                    .padding()
            }
        }
    }
}

#Preview {
    NavigationView {
        PostDetailView(
            post: [Post].mocks.first!,
            user: [User].mocks.first!
        )
    }
}

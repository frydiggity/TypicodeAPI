import Perception
import SwiftUI

// MARK: - Posts View

public struct PostsView: View {
    
    let model: PostsViewModel
    
    public init(model: PostsViewModel) {
        self.model = model
    }
    
    public var body: some View {
        WithPerceptionTracking {
            VStack(alignment: .center) {
                switch model.state {
                case .loading:
                    ProgressView {
                        Text("Loading Posts...")
                    }
                    .task { await model.load() }

                    
                case .loaded(let posts):
                    List {
                        ForEach(posts) { post in
                            NavigationLink(destination: PostDetailView(post: post, user: model.users[post.userId])) {
                                VStack(alignment: .leading) {
                                    Text(post.title)
                                    Text(post.body)
                                        .font(.caption)
                                        .lineLimit(1)
                                }
                            }
                        }
                    }
                    
                case .error(let errorState):
                    if #available(iOS 17.0, *) {
                        ContentUnavailableView(
                            errorState.title,
                            systemImage: "exclamationmark.triangle",
                            description: Text(errorState.description)
                        )
                        .padding()
                    } else {
                        Text(errorState.title)
                        Text(errorState.description)
                    }
                }
            }
        }
        .navigationTitle("Lorem Ipsum Posts")
    }
}

// MARK: - Previews

import Dependencies
import NetworkClient

#Preview("Posts - Unloaded State (Default)") {
    NavigationView {
        PostsView(model: PostsViewModel())
    }
}

#Preview("Posts - Loading State") {
    let slowLoadingMocksViewModel = withDependencies {
        $0.networkClient = .slowLoadingMocks
    } operation: {
        PostsViewModel(state: .loading)
    }
    
    NavigationView {
        PostsView(model: slowLoadingMocksViewModel)
    }
}

#Preview("Posts - Error State") {
    NavigationView {
        PostsView(
            model: PostsViewModel(
                state: .error(
                    .init(
                        title: "Error Title",
                        description: "Error description"
                    )
                )
            )
        )
    }
}

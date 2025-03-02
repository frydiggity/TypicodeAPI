import Features
import SwiftUI

@main
struct TypicodeAPIApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                PostsView(model: PostsViewModel())
            }
        }
    }
}

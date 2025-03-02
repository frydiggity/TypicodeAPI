import Models
import SwiftUI

struct UserBugView: View {
    let user: User
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(user.name)
                .bold()
            Text(user.email)
                .font(.caption)
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.primary, lineWidth: 1)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.thickMaterial)
                )
        )
        .overlay(alignment: .topLeading) {
            Image(systemName: "person")
                .resizable()
                .frame(width: 25, height: 25)
                .padding(6)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.primary, lineWidth: 1)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(.thickMaterial)
                        )
                )
                .offset(x: 8, y: -18)
        }
    }
}

#Preview {
    UserBugView(user: [User].mocks.first!)
}

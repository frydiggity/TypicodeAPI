import Models
import Testing

@Test("User initializer accepts Int literal as id and fills fields correctly")
func userInitializer() async throws {
    let user = User(
        id: 1,
        name: "Test User",
        username: "testuser",
        email: "test@example.com",
        address: .init(
            street: "Baldwin",
            city: "Quincy",
            zipcode: "62301",
            geo: .init(
                lat: "39.931882",
                long: "-91.403969"
            )
        ),
        phone: "+1-573-551-4280",
        website: "https://github.com/",
        company: .init(
            name: "Dempsey-Conroy",
            catchPhrase: "User-centric impactful vortices",
            bs: "synergize cutting-edge solutions"
        )
    )
    
    #expect(user.id == 1)
    #expect(user.name == "Test User")
    #expect(user.username == "testuser")
    #expect(user.email == "test@example.com")
    #expect(user.address.street == "Baldwin")
    #expect(user.address.suite == nil)
    #expect(user.address.city == "Quincy")
    #expect(user.address.zipcode == "62301")
    #expect(user.address.geo.lat == "39.931882")
    #expect(user.address.geo.long == "-91.403969")
    #expect(user.phone == "+1-573-551-4280")
    #expect(user.website == "https://github.com/")
    #expect(user.company.name == "Dempsey-Conroy")
    #expect(user.company.catchPhrase == "User-centric impactful vortices")
    #expect(user.company.bs == "synergize cutting-edge solutions")
}

@Test("Post initializer accepts Int literal as id and user.id and fills fields correctly")
func postInitializer() async throws {
    let post = Post(
        id: 9,
        userId: 8,
        title: "The title of the post",
        body: "Some really great insights"
    )
    
    #expect(post.id == 9)
    #expect(post.userId == 8)
    #expect(post.title == "The title of the post")
    #expect(post.body == "Some really great insights")
}

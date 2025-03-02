#if DEBUG

public extension Array where Element == User {
    static let mocks: [User] = [
        .init(
            id: 5,
            name: "Steve Erwin",
            username: "Steve",
            email: "Sincere@april.biz",
            address: .init(street: "1st Street", city: "Anytown", zipcode: "12345", geo: .init(lat: "99.0", lng: "-123.45")),
            phone: "+1-555-867-5309",
            website: "https://giggle.com",
            company: .init(name: "Acme", catchPhrase: "We almost get roadrunners", bs: "Roadrunner gone or you go boom")
        ),
        .init(
            id: 6,
            name: "Al Yankovich",
            username: "Al",
            email: "Al.Yankovich@gmail.com",
            address: .init(street: "2nd Street", city: "Anytown", zipcode: "12345", geo: .init(lat: "99.0", lng: "-123.45")),
            phone: "+1-555-555-5555",
            website: "https://gaggle.com",
            company: .init(name: "Acme", catchPhrase: "We almost get roadrunners", bs: "Roadrunner gone or you go boom")
        ),
    ]
}

public extension Array where Element == Post {
    static let mocks: [Post] = [
        .init(id: 10, userId: 5, title: "First post title", body: "First post body"),
        .init(id: 11, userId: 6, title: "Second post title", body: "Second post body"),
        .init(id: 12, userId: 5, title: "Third post title", body: "Thirs post body"),
    ]
}

#endif

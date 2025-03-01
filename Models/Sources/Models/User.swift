import Foundation
import Tagged

public struct User: Identifiable, Hashable, Sendable, Decodable {
    
    // MARK: - Typealias
    
    public typealias ID = Tagged<User, Int>
    
    // MARK: - Public Properties
    
    public let id: ID
    public let name: String
    public let username: String
    public let email: String
    public let address: Address
    public let phone: String
    public let website: String
    public let company: Company
    
    // MARK: - Initializers
    
    public init(
        id: Tagged<User, Int>,
        name: String,
        username: String,
        email: String,
        address: Address,
        phone: String,
        website: String,
        company: Company
    ) {
        self.id = id
        self.name = name
        self.username = username
        self.email = email
        self.address = address
        self.phone = phone
        self.website = website
        self.company = company
    }
    
    // MARK: - Nested Types
    
    public struct Address: Hashable, Sendable, Decodable {
        public let street: String
        public let suite: String?
        public let city: String
        public let zipcode: String
        public let geo: Geo
        
        public init(
            street: String,
            suite: String? = nil,
            city: String,
            zipcode: String,
            geo: Geo
        ) {
            self.street = street
            self.suite = suite
            self.city = city
            self.zipcode = zipcode
            self.geo = geo
        }
        
        public struct Geo: Hashable, Sendable, Decodable {
            public let lat: String
            public let long: String
            
            public init(lat: String, long: String) {
                self.lat = lat
                self.long = long
            }
        }
    }
    
    public struct Company: Hashable, Sendable, Decodable {
        public let name: String
        public let catchPhrase: String
        public let bs: String
        
        public init(name: String, catchPhrase: String, bs: String) {
            self.name = name
            self.catchPhrase = catchPhrase
            self.bs = bs
        }
    }
}

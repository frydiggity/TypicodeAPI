import Dependencies
import Foundation

public class TypicodeJSONDecoder: JSONDecoder, @unchecked Sendable {
    override init() {
        super.init()
        
        // Custom decoding configuration here specific to the API contract with the particular API used
        // (dates not used in typicode data, but for example):
        dateDecodingStrategy = .iso8601
    }
}

public extension DependencyValues {
    var typicodeJSONDecoder: @Sendable () -> TypicodeJSONDecoder {
        get { self[TypicodeJSONDecoder.self] }
        set { self[TypicodeJSONDecoder.self] = newValue }
    }
}

extension JSONDecoder: @retroactive DependencyKey {
    public typealias Value = @Sendable () -> TypicodeJSONDecoder
    
    public static let liveValue: @Sendable () -> TypicodeJSONDecoder = {
        TypicodeJSONDecoder()
    }
    
    // This saves us from having to explicitly define the typicodeJSONDecoder dependency value to use
    // in tests - safe to do here because we're never going to override it
    public static let testValue = liveValue
}

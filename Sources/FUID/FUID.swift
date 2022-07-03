import Foundation

public struct FUID: RawRepresentable {
    public var rawValue: String
    
    public init?(rawValue: String) {
        guard
            !rawValue.isEmpty,
            rawValue.allSatisfy({ alphabet.contains($0) })
        else {
            return nil
        }
        self.rawValue = rawValue
    }
    
    public init?(_ string: String) {
        self.init(rawValue: string)
    }
    
    public init(uuid: UUID) {
        self.init(rawValue: Base62.encode(uuid: uuid))!
    }
    
    public init() {
        self.init(uuid: UUID())
    }
    
    public var uuid: UUID? {
        Base62.decodeToUUID(rawValue)
    }
}

extension FUID: CustomStringConvertible {
    public var description: String {
        rawValue
    }
}

extension FUID: Hashable {
}

extension FUID: Codable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(rawValue)
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.rawValue = try container.decode(String.self)
    }
}

extension FUID: ExpressibleByStringLiteral {
    public init(stringLiteral value: StringLiteralType) {
        self.init(rawValue: value)!
    }
}

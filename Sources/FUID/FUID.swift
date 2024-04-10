import Foundation
import NumberKit

public struct FUID: RawRepresentable {
    public let rawValue: String
    public let value: BigInt
    
    public init?(rawValue: String) {
        guard
            !rawValue.isEmpty,
            let value = Base62.decodeToBigInt(rawValue)
        else {
            return nil
        }
        self.rawValue = rawValue
        self.value = value
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
    public func hash(into hasher: inout Hasher) {
        hasher.combine(value)
    }
}

extension FUID: Comparable {
    public static func < (lhs: FUID, rhs: FUID) -> Bool {
        lhs.value < rhs.value
    }
}

extension FUID: Codable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(rawValue)
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(String.self)
        guard let s = Self(rawValue: rawValue) else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid FUID")
        }
        self = s
    }
}

extension FUID: ExpressibleByStringLiteral {
    public init(stringLiteral value: StringLiteralType) {
        self.init(rawValue: value)!
    }
}

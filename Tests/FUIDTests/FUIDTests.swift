import Testing
import Foundation
@testable import FUID

struct FUIDTests {
    @Test func testBase62() {
        #expect(Base62.decodeToBigInt("F0ob4rZ")! == "852751187393")
        #expect(Base62.encode(base10: "852751187393") == "F0ob4rZ")
    }
    
    @Test func testBase62DecodeInvalidChar() {
        #expect(Base62.decodeToBigInt("ds{Z455f") == nil)
    }
    
    @Test func testBase62DecodeLongString() {
        #expect(Base62.decodeToBigInt("dsZ455fzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz") == nil)
    }
    
    @Test func testBase62UUID() {
        let uuid = UUID(uuidString: "D9F540AC-F699-47BE-B309-E6C15877639B")!
        let base62 = "6dHPm31SUz4d5nt9qNNKQ7"
        #expect(Base62.encode(uuid: uuid) == base62)
        #expect(Base62.decodeToUUID(base62) == uuid)
    }
    
    @Test func testFUID() {
        let fuidString = "2OoRTgKNblbnwE3X5RCTFq"
        let uuidString = "4EDD18E1-CDA7-4E9A-939D-7730A32054BA"
        let fuid = FUID(fuidString)!
        #expect(fuid.description == fuidString)
        
        let fuidJSON = fuid.jsonString
        #expect(fuidJSON == fuidString.flanked("\""))
        
        let fuid2 = try! FUID.fromJSON(fuidJSON)
        #expect(fuid == fuid2)
        
        #expect(fuid.uuid!.description == uuidString)
    }
    
    @Test func testOrder() {
        // Formerly used lexicographic ordering, but now uses numeric ordering, which is
        // the same as the Rust implementation.
        let fuids: [FUID] = ["BA", "BC", "JA", "JA2", "JE"]
        #expect(fuids.sorted().description == "[BA, BC, JA, JE, JA2]")
    }
}


extension Encodable {
    func json(outputFormatting: JSONEncoder.OutputFormatting = []) -> Data {
        let encoder = JSONEncoder()
        encoder.outputFormatting = outputFormatting
        return try! encoder.encode(self)
    }
    
    func jsonString(outputFormatting: JSONEncoder.OutputFormatting = []) -> String {
        json(outputFormatting: outputFormatting).utf8!
    }
    
    var json: Data {
        json(outputFormatting: .sortedKeys)
    }

    var jsonString: String {
        json.utf8!
    }
}

extension Data {
    var utf8: String? {
        toUTF8(data: self)
    }
}

func toUTF8(data: Data) -> String? {
    String(data: data, encoding: .utf8)
}

extension StringProtocol {
    func flanked(_ leading: String, _ trailing: String) -> String {
        leading + self + trailing
    }

    func flanked(_ around: String) -> String {
        around + self + around
    }
}

extension Data {
    var hex: String {
        toHex(data: self)
    }
}

extension String {
    var utf8Data: Data {
        toData(utf8: self)
    }
    
    var hexData: Data? {
        toData(hex: self)
    }
}

func toData(utf8: String) -> Data {
    utf8.data(using: .utf8)!
}

func toHex(byte: UInt8) -> String {
    String(format: "%02x", byte)
}

func toHex(data: Data) -> String {
    data.reduce(into: "") {
        $0 += toHex(byte: $1)
    }
}

func _fromJSON<T>(_ t: T.Type, _ json: Data) throws -> T where T : Decodable {
    try JSONDecoder().decode(T.self, from: json)
}

func _fromJSON<T>(_ t: T.Type, _ json: String) throws -> T where T : Decodable {
    try _fromJSON(T.self, json.utf8Data)
}

extension Decodable {
    static func fromJSON(_ data: Data) throws -> Self {
        try _fromJSON(Self.self, data)
    }

    static func fromJSON(_ jsonString: String) throws -> Self {
        try _fromJSON(Self.self, jsonString)
    }
}

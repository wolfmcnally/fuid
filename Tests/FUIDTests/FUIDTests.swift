import Testing
import WolfBase
import Foundation
@testable import FUID

struct FUIDTests {
    @Test func testBase62() {
        #expect(Base62.decodeToBigInt("F0ob4rZ")† == "852751187393")
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
        #expect(fuids.sorted()† == "[BA, BC, JA, JE, JA2]")
    }
}

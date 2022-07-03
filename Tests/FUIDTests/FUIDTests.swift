import XCTest
import WolfBase
@testable import FUID

final class FUIDTests: XCTestCase {
    func testBase62() {
        XCTAssertEqual(Base62.decodeToBigInt("F0ob4rZ")†, "852751187393")
        XCTAssertEqual(Base62.encode(base10: "852751187393"), "F0ob4rZ")
    }
    
    func testBase62DecodeInvalidChar() {
        XCTAssertNil(Base62.decodeToBigInt("ds{Z455f"))
    }
    
    func testBase62DecodeLongString() {
        XCTAssertNil(Base62.decodeToBigInt("dsZ455fzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz"))
    }
    
    func testBase62UUID() {
        let uuid = UUID(uuidString: "D9F540AC-F699-47BE-B309-E6C15877639B")!
        let base62 = "6dHPm31SUz4d5nt9qNNKQ7"
        XCTAssertEqual(Base62.encode(uuid: uuid), base62)
        XCTAssertEqual(Base62.decodeToUUID(base62), uuid)
    }
    
    func testFUID() {
        let fuidString = "2OoRTgKNblbnwE3X5RCTFq"
        let uuidString = "4EDD18E1-CDA7-4E9A-939D-7730A32054BA"
        let fuid = FUID(fuidString)!
        XCTAssertEqual(fuid.description, fuidString)
        
        let fuidJSON = fuid.jsonString
        XCTAssertEqual(fuidJSON, fuidString.flanked("\""))
        
        let fuid2 = try! FUID.fromJSON(fuidJSON)
        XCTAssertEqual(fuid, fuid2)
        
        XCTAssertEqual(fuid.uuid!.description, uuidString)
    }
}

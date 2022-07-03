import XCTest
@testable import FUID

final class FUIDTests: XCTestCase {
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(FUID().text, "Hello, World!")
    }
}

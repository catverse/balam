import XCTest
@testable import Balam

final class BalamTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(Balam().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}

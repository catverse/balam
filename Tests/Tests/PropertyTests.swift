import XCTest
import Combine
@testable import Balam

final class PropertyTests: XCTestCase {
    func testEquality() {
        XCTAssertEqual(StringProperty("a"), StringProperty("a"))
        XCTAssertNotEqual(StringProperty("a"), IntProperty("a"))
    }
}

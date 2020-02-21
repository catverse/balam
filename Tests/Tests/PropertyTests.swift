import XCTest
import Combine
@testable import Balam

final class PropertyTests: XCTestCase {
    func testEquality() {
        XCTAssertEqual(Property.String("a"), Property.String("a"))
        XCTAssertNotEqual(Property.String("a"), Property.String("b"))
        XCTAssertNotEqual(Property.String("a"), Property.Int("a"))
        XCTAssertEqual(Property.Optional(Property.String("a")), Property.Optional(Property.String("a")))
        XCTAssertNotEqual(Property.Optional(Property.String("a")), Property.String("a"))
        XCTAssertNotEqual(Property.Optional(Property.String("a")), Property.Optional(Property.String("b")))
    }
}

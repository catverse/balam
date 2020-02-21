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
        XCTAssertEqual(Property.Array(Property.String("a")), Property.Array(Property.String("a")))
        XCTAssertNotEqual(Property.Array(Property.String("a")), Property.Array(Property.String("b")))
        XCTAssertNotEqual(Property.Array(Property.String("a")), Property.Optional(Property.String("a")))
        XCTAssertEqual(Property.Optional(Property.Array(Property.String("a"))), Property.Optional(Property.Array(Property.String("a"))))
        XCTAssertNotEqual(Property.Optional(Property.Array(Property.String("a"))), Property.Optional(Property.Array(Property.String("b"))))
        XCTAssertNotEqual(Property.Array(Property.Optional(Property.String("a"))), Property.Optional(Property.Array(Property.String("a"))))
        XCTAssertEqual(Property.Dictionary("a", key: Property.String(""), value: Property.Int("")), Property.Dictionary("a", key: Property.String(""), value: Property.Int("")))
        XCTAssertNotEqual(Property.Dictionary("a", key: Property.String(""), value: Property.Int("")), Property.Dictionary("b", key: Property.String(""), value: Property.Int("")))
    }
    
    func testHashable() {
        XCTAssertEqual(1, Set<Property>([Property.String("a"), Property.String("a"), Property.String("a")]).count)
        XCTAssertEqual(2, Set<Property>([Property.String("a"), Property.Int("a")]).count)
        XCTAssertEqual(2, Set<Property>([Property.String("a"), Property.String("b")]).count)
        XCTAssertEqual(2, Set<Property>([Property.String("a"), Property.Optional(Property.String("a"))]).count)
        XCTAssertEqual(1, Set<Property>([Property.Optional(Property.String("a")), Property.Optional(Property.String("a"))]).count)
    }
}

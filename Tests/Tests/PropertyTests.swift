import XCTest
import Combine
@testable import Balam

final class PropertyTests: XCTestCase {
    func testEquality() {
        XCTAssertEqual(.String("a"), Property.String("a"))
        XCTAssertNotEqual(.String("a"), Property.String("b"))
        XCTAssertNotEqual(.String("a"), Property.Int("a"))
        XCTAssertEqual(.Optional(.String("a")), Property.Optional(.String("a")))
        XCTAssertNotEqual(.Optional(.String("a")), Property.String("a"))
        XCTAssertNotEqual(.Optional(.String("a")), Property.Optional(.String("b")))
        XCTAssertEqual(.Array(.String("a")), Property.Array(.String("a")))
        XCTAssertNotEqual(.Array(.String("a")), Property.Array(.String("b")))
        XCTAssertNotEqual(.Array(.String("a")), Property.Optional(.String("a")))
        XCTAssertEqual(.Optional(.Array(.String("a"))), Property.Optional(.Array(.String("a"))))
        XCTAssertNotEqual(.Optional(.Array(.String("a"))), Property.Optional(.Array(.String("b"))))
        XCTAssertNotEqual(.Array(.Optional(.String("a"))), Property.Optional(.Array(.String("a"))))
        XCTAssertEqual(.Dictionary("a", key: .String(""), value: .Int("")), Property.Dictionary("a", key: .String(""), value: .Int("")))
        XCTAssertNotEqual(.Dictionary("a", key: .String(""), value: .Int("")), Property.Dictionary("b", key: .String(""), value: .Int("")))
    }
    
    func testHashable() {
        XCTAssertEqual(1, Set<Property>([.String("a"), .String("a"), .String("a")]).count)
        XCTAssertEqual(2, Set<Property>([.String("a"), .Int("a")]).count)
        XCTAssertEqual(2, Set<Property>([.String("a"), .String("b")]).count)
        XCTAssertEqual(2, Set<Property>([.String("a"), .Optional(.String("a"))]).count)
        XCTAssertEqual(1, Set<Property>([.Optional(.String("a")), .Optional(.String("a"))]).count)
    }
}

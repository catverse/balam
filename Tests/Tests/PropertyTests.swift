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
        XCTAssertEqual(.Custom("a"), Property.Custom("a"))
        XCTAssertNotEqual(.Custom("a"), Property.Custom("b"))
    }
    
    func testHashable() {
        XCTAssertEqual(1, Set<Property>([.String("a"), .String("a"), .String("a")]).count)
        XCTAssertEqual(2, Set<Property>([.String("a"), .Int("a")]).count)
        XCTAssertEqual(2, Set<Property>([.String("a"), .String("b")]).count)
        XCTAssertEqual(2, Set<Property>([.String("a"), .Optional(.String("a"))]).count)
        XCTAssertEqual(1, Set<Property>([.Optional(.String("a")), .Optional(.String("a"))]).count)
        XCTAssertEqual(1, Set<Property>([.Custom("a"), .Custom("a")]).count)
    }
    
    func testGuess() {
        struct Model: Codable {
            var b = "c"
            var a: Int? = nil
        }
        var model = try! JSONSerialization.jsonObject(with: JSONEncoder().encode(Model())) as! [String : Any]
        model["a"] = ""
        let decoded = try! JSONDecoder().decode(Model.self, from: JSONSerialization.data(withJSONObject: model))
        print(decoded.a)
    }
}

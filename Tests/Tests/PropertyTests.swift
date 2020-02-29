import XCTest
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
    
    func testString() {
        struct Model: Codable {
            var a = ""
        }
        
        let node = Node(Model())
        XCTAssertEqual(Property.String("a"), try? JSONDecoder().decode(Node.self, from: JSONEncoder().encode(node)).properties.first)
    }
    
    func testDouble() {
        struct Model: Codable {
            var a = Double()
        }
        
        let node = Node(Model())
        XCTAssertEqual(Property.Double("a"), try? JSONDecoder().decode(Node.self, from: JSONEncoder().encode(node)).properties.first)
    }
    
    func testOptionalString() {
        struct Model: Codable {
            var a: String? = ""
        }
        
        let node = Node(Model())
        XCTAssertEqual(Property.Optional(.String("a")), try? JSONDecoder().decode(Node.self, from: JSONEncoder().encode(node)).properties.first)
    }
    
    func testOptionalArrayString() {
        struct Model: Codable {
            var a: [String]? = [""]
        }
        
        let node = Node(Model())
        XCTAssertEqual(Property.Optional(.Array(.String("a"))), try? JSONDecoder().decode(Node.self, from: JSONEncoder().encode(node)).properties.first)
    }
    
    func testThreeProperties() {
        struct Model: Codable {
            var a = Double()
            var b = String()
            var c = Int()
        }
        
        let node = Node(Model())
        XCTAssertEqual(3, try? JSONDecoder().decode(Node.self, from: JSONEncoder().encode(node)).properties.count)
    }
    
    func testDictionary() {
        struct Model: Codable {
            var a = ["hello" : 1]
        }
        
        let node = Node(Model())
        XCTAssertEqual(Property.Dictionary("a", key: .String(""), value: .Int("")), try? JSONDecoder().decode(Node.self, from: JSONEncoder().encode(node)).properties.first)
    }
}

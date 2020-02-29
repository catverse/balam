import XCTest
@testable import Balam

final class SerialiserTests: XCTestCase {
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
}

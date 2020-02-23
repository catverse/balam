import XCTest
import Combine
@testable import Balam

@available(OSX 10.15, *) final class NodeTests: XCTestCase {
    func testParse() {
        struct Model: Codable {
            let arrString = [String]()
            let arrStringOptional = [String?]()
            let opString: String? = "opt"
            let opInt: Int? = 9
            let name = "Lorem Ipsum"
            let age = 99
            let phone = 2.3
            let myBool = false
            var opNilString: String? = nil
            var opNilInt: Int? = nil
            var opNilDouble: Double? = nil
            var opNilBool: Bool? = nil
        }
        
        let node = Node(Model())
        XCTAssertEqual("Model", node.name)
        XCTAssertNotNil(node.properties.compactMap { $0 as? Property.String }.first { $0.name == "name" })
        XCTAssertNotNil(node.properties.compactMap { $0 as? Property.Int }.first { $0.name == "age" })
        XCTAssertNotNil(node.properties.compactMap { $0 as? Property.Double }.first { $0.name == "phone" })
        XCTAssertNotNil(node.properties.compactMap { $0 as? Property.Boolean }.first { $0.name == "myBool" })
        XCTAssertNotNil(node.properties.compactMap { $0 as? Property.Optional }.first { ($0.property as? Property.String)?.name == "opString" })
        XCTAssertNotNil(node.properties.compactMap { $0 as? Property.Optional }.first { ($0.property as? Property.Int)?.name == "opInt" })
        XCTAssertNotNil(node.properties.compactMap { $0 as? Property.Array }.first { ($0.property as? Property.String)?.name == "arrString" })
        XCTAssertNotNil(node.properties.compactMap { $0 as? Property.Array }.first { ($0.property as? Property.String)?.name == "arrStringOptional" })
        XCTAssertNotNil(node.properties.compactMap { $0 as? Property.Optional }.first { ($0.property as? Property.String)?.name == "opNilString" })
        XCTAssertNotNil(node.properties.compactMap { $0 as? Property.Optional }.first { ($0.property as? Property.Int)?.name == "opNilInt" })
        XCTAssertNotNil(node.properties.compactMap { $0 as? Property.Optional }.first { ($0.property as? Property.Double)?.name == "opNilDouble" })
        XCTAssertNotNil(node.properties.compactMap { $0 as? Property.Optional }.first { ($0.property as? Property.Boolean)?.name == "opNilBool" })
    }
}

import XCTest
import Combine
@testable import Balam

@available(OSX 10.15, *) final class NodeTests: XCTestCase {
    func testParse() {
        struct Model {
            let arrString = [String]()
            let arrStringOptional = [String?]()
            let opString: String? = "opt"
            let opInt: Int? = 9
        //    let opNilString: String? = nil
        //    let opNilInt: Int? = nil
            let name = "Lorem Ipsum"
            let age = 99
            let phone = 2.3
        }
        
        let node = Node(Model())
        XCTAssertEqual("Model", node.name)
        XCTAssertNotNil(node.properties.compactMap { $0 as? Property.String }.first { $0.name == "name" })
        XCTAssertNotNil(node.properties.compactMap { $0 as? Property.Int }.first { $0.name == "age" })
        XCTAssertNotNil(node.properties.compactMap { $0 as? Property.Double }.first { $0.name == "phone" })
        XCTAssertNotNil(node.properties.compactMap { $0 as? Property.Optional }.first { ($0.property as? Property.String)?.name == "opString" })
        XCTAssertNotNil(node.properties.compactMap { $0 as? Property.Optional }.first { ($0.property as? Property.Int)?.name == "opInt" })
        XCTAssertNotNil(node.properties.compactMap { $0 as? Property.Array }.first { ($0.property as? Property.String)?.name == "arrString" })
        XCTAssertNotNil(node.properties.compactMap { $0 as? Property.Array }.first { (($0.property as? Property.Optional)?.property as? Property.String)?.name == "arrStringOptional" })
    }
    
    func testArray() {
        struct Model {
            let arr = [String?]()
        }
        
        let node = Node(Model())
        XCTAssertNotNil(node.properties.compactMap { $0 as? Property.Array }.first { ($0.property as? Property.String)?.name == "arr" })
    }
}

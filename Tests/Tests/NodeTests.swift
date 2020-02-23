import XCTest
import Combine
@testable import Balam

@available(OSX 10.15, *) final class NodeTests: XCTestCase {
    func testParse() {
        struct Model: Codable {
            var arrString = [String]()
            var arrStringOptional = [String?]()
            var opString: String? = "opt"
            var opInt: Int? = 9
            var name = "Lorem Ipsum"
            var age = 99
            var phone = 2.3
            var myBool = false
            var arrInt = [Int]()
            var arrDouble = [Double]()
            var arrStringOp: [String]? = []
            var opNilString: String? = nil
            var opNilInt: Int? = nil
            var opNilDouble: Double? = nil
            var opNilBool: Bool? = nil
            var arrStringNil: [String]?
            var arrIntNil: [Int]?
            var arrDoubleNil: [Double]?
            var arrBoolNil: [Bool]?
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
        XCTAssertNotNil(node.properties.compactMap { $0 as? Property.Optional }.first { (($0.property as? Property.Array)?.property as? Property.String)?.name == "arrStringOp" })
        XCTAssertNotNil(node.properties.compactMap { $0 as? Property.Optional }.first { (($0.property as? Property.Array)?.property as? Property.String)?.name == "arrStringNil" })
        XCTAssertNotNil(node.properties.compactMap { $0 as? Property.Array }.first { ($0.property as? Property.Int)?.name == "arrInt" })
        XCTAssertNotNil(node.properties.compactMap { $0 as? Property.Optional }.first { (($0.property as? Property.Array)?.property as? Property.Int)?.name == "arrIntNil" })
        XCTAssertNotNil(node.properties.compactMap { $0 as? Property.Array }.first { ($0.property as? Property.Double)?.name == "arrDouble" })
        XCTAssertNotNil(node.properties.compactMap { $0 as? Property.Optional }.first { (($0.property as? Property.Array)?.property as? Property.Double)?.name == "arrDoubleNil" })
        XCTAssertNotNil(node.properties.compactMap { $0 as? Property.Optional }.first { (($0.property as? Property.Array)?.property as? Property.Boolean)?.name == "arrBoolNil" })
    }
}

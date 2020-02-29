import XCTest
@testable import Balam

@available(OSX 10.15, *) final class NodeTests: XCTestCase {
    func testParse() {
        struct Model: Codable {
            var uint8 = UInt8()
            var uint16 = UInt16()
            var uint32 = UInt32()
            var uint64 = UInt64()
            var int8 = Int8()
            var int16 = Int16()
            var int32 = Int32()
            var int64 = Int64()
            var float = Float()
            var timeInterval = TimeInterval()
            var date = Date()
            var data = Data()
            var arrString = [String]()
            var arrArrString = [[String]]()
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
            var uint8Nil: UInt8?
            var timeIntervalNil: TimeInterval?
            var dateNil: Date?
            var dataNil: Data?
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
        XCTAssertNotNil(node.properties.compactMap { $0 as? Property.UInt8 }.first { $0.name == "uint8" })
        XCTAssertNotNil(node.properties.compactMap { $0 as? Property.UInt16 }.first { $0.name == "uint16" })
        XCTAssertNotNil(node.properties.compactMap { $0 as? Property.UInt32 }.first { $0.name == "uint32" })
        XCTAssertNotNil(node.properties.compactMap { $0 as? Property.UInt64 }.first { $0.name == "uint64" })
        XCTAssertNotNil(node.properties.compactMap { $0 as? Property.Int8 }.first { $0.name == "int8" })
        XCTAssertNotNil(node.properties.compactMap { $0 as? Property.Int16 }.first { $0.name == "int16" })
        XCTAssertNotNil(node.properties.compactMap { $0 as? Property.Int32 }.first { $0.name == "int32" })
        XCTAssertNotNil(node.properties.compactMap { $0 as? Property.Int64 }.first { $0.name == "int64" })
        XCTAssertNotNil(node.properties.compactMap { $0 as? Property.Float }.first { $0.name == "float" })
        XCTAssertNotNil(node.properties.compactMap { $0 as? Property.Double }.first { $0.name == "timeInterval" })
        XCTAssertNotNil(node.properties.compactMap { $0 as? Property.Date }.first { $0.name == "date" })
        XCTAssertNotNil(node.properties.compactMap { $0 as? Property.Data }.first { $0.name == "data" })
        XCTAssertNotNil(node.properties.compactMap { $0 as? Property.Optional }.first { ($0.property as? Property.UInt8)?.name == "uint8Nil" })
        XCTAssertNotNil(node.properties.compactMap { $0 as? Property.Optional }.first { ($0.property as? Property.Double)?.name == "timeIntervalNil" })
        XCTAssertNotNil(node.properties.compactMap { $0 as? Property.Optional }.first { ($0.property as? Property.Date)?.name == "dateNil" })
        XCTAssertNotNil(node.properties.compactMap { $0 as? Property.Optional }.first { ($0.property as? Property.Data)?.name == "dataNil" })
        XCTAssertNotNil(node.properties.compactMap { $0 as? Property.Array }.first { (($0.property as? Property.Array)?.property as? Property.String)?.name == "arrArrString" })
    }
}

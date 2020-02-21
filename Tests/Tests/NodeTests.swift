import XCTest
import Combine
@testable import Balam

@available(OSX 10.15, *) final class NodeTests: XCTestCase {
    func testAddNode() {
        let node = Node(Model())
        XCTAssertEqual("Model", node.name)
        XCTAssertNotNil(node.properties.compactMap { $0 as? Property.String }.first { $0.name == "name" })
        XCTAssertNotNil(node.properties.compactMap { $0 as? Property.Int }.first { $0.name == "age" })
    }
}

private struct Model {
    let opString: String? = "opt"
    let opNilString: String? = nil
    let opNilInt: Int? = nil
    let name = "Lorem Ipsum"
    let age = 99
    let phone = 2.3
}

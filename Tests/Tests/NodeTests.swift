import XCTest
import Combine
@testable import Balam

@available(OSX 10.15, *) final class NodeTests: XCTestCase {
    func testAddNode() {
        let node = Node(Model())
        XCTAssertEqual("Model", node.name)
        XCTAssertEqual(.string, node.description["name"])
        XCTAssertEqual(.int, node.description["age"])
        XCTAssertEqual(.double, node.description["phone"])
        XCTAssertEqual(.optionalString, node.description["opString"])
        XCTAssertEqual(.optionalString, node.description["opNilString"])
        XCTAssertEqual(.optionalInt, node.description["opNilInt"])
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

import XCTest
import Combine
@testable import Balam

@available(OSX 10.15, *) final class GraphTests: XCTestCase {
    private var url: URL!
    private var subs: Set<AnyCancellable>!
    
    override func setUp() {
        subs = .init()
        url = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("test")
        try? FileManager.default.removeItem(at: url)
    }
    
    override func tearDown() {
        try? FileManager.default.removeItem(at: url)
    }
    
    func testAddNode() {
        let graph = Graph(url)
        graph._add(User())
        XCTAssertEqual(1, graph.nodes.count)
        XCTAssertEqual("User", graph.nodes.first?.name)
        XCTAssertEqual(.string, graph.nodes.first?.description["name"])
        XCTAssertEqual(.int, graph.nodes.first?.description["age"])
        XCTAssertEqual(1, graph.nodes.first?.items.count)
    }
    
    func testAddThreeNodes() {
        let graph = Graph(url)
        var first = User()
        first.name = "some name"
        first.age = 22
        var last = User()
        last.name = "Ipsum Lorem"
        last.age = 33
        graph._add(first)
        graph._add(User())
        graph._add(last)
        XCTAssertEqual(1, graph.nodes.count)
        XCTAssertEqual("User", graph.nodes.first?.name)
        XCTAssertEqual(3, graph.nodes.first?.items.count)
    }
    
    func testAddAndRetrieveNode() {
        let graph = Graph(url)
        graph._add(User())
        let users = graph._nodes(User.self)
        XCTAssertEqual(1, users?.count)
        XCTAssertEqual("Lorem Ipsum", users?.first?.name)
        XCTAssertEqual(99, users?.first?.age)
    }
    
    func testUpdateNode() {
        let graph = Graph(url)
        graph._add(UserWithId())
        var user = graph._nodes(UserWithId.self)!.first!
        user.name = "hello world"
        user.age = 456
        graph._update(user)
        let users = graph._nodes(UserWithId.self)
        XCTAssertEqual(1, users?.count)
        XCTAssertEqual("hello world", users?.first?.name)
        XCTAssertEqual(456, users?.first?.age)
    }
}

private struct User: Codable {
    var name = "Lorem Ipsum"
    var age = 99
}

private struct UserWithId: Codable, Identifiable {
    var id = 0
    var name = "Some anme"
    var age = 123
}

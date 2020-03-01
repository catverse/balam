import XCTest
@testable import Balam

@available(OSX 10.15, *) final class GraphTests: XCTestCase {
    private var url: URL!
    
    override func setUp() {
        url = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("test")
        try? FileManager.default.removeItem(at: url)
    }
    
    override func tearDown() {
        try? FileManager.default.removeItem(at: url)
    }
    
    func testAddNode() {
        let graph = Graph(url, queue: .main)
        try! FileManager.default.removeItem(at: url)
        graph._add(User())
        XCTAssertEqual(1, graph.nodes.count)
        XCTAssertEqual("User", graph.nodes.first?.name)
        XCTAssertEqual(1, graph.nodes.first?.items.count)
        XCTAssertTrue(FileManager.default.fileExists(atPath: url.path))
    }
    
    func testAddThreeNodes() {
        let graph = Graph(url, queue: .main)
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
        graph.nodes.forEach {
            XCTAssertEqual("User", $0.name)
            XCTAssertEqual(3, $0.items.count)
        }
    }
    
    func testAddAndRetrieveNode() {
        let graph = Graph(url, queue: .main)
        graph._add(User())
        let users = graph._nodes(User.self)
        XCTAssertEqual(1, users?.count)
        XCTAssertEqual("Lorem Ipsum", users?.first?.name)
        XCTAssertEqual(99, users?.first?.age)
    }
    
    func testUpdateNode() {
        let graph = Graph(url, queue: .main)
        try! FileManager.default.removeItem(at: url)
        graph._add(UserWithId())
        var user = graph._nodes(UserWithId.self)!.first!
        user.name = "hello world"
        user.age = 456
        graph._update(user)
        let users = graph._nodes(UserWithId.self)
        XCTAssertEqual(1, users?.count)
        XCTAssertEqual("hello world", users?.first?.name)
        XCTAssertEqual(456, users?.first?.age)
        XCTAssertTrue(FileManager.default.fileExists(atPath: url.path))
    }
    
    func testDifferentClassesSameName() {
        let graph = Graph(url, queue: .main)
        addClassv1(graph)
        addClassv2(graph)
        XCTAssertEqual(2, graph.nodes.count)
        graph.nodes.forEach {
            XCTAssertEqual("Model", $0.name)
            XCTAssertEqual(1, $0.items.count)
        }
    }
    
    func testAddDuplicate() {
        let graph = Graph(url, queue: .main)
        var user = UserWithId()
        graph._add(user)
        user.name = "another name"
        user.age = 321
        graph._add(user)
        XCTAssertEqual(1, graph._nodes(UserWithId.self)?.count)
    }
    
    private func addClassv1(_ graph: Graph) {
        struct Model: Codable {
            let phone: Float
            let number: Int
        }
        _ = graph._nodes(Model.self)
        graph._add(Model(phone: 12.3, number: 4543))
        let models = graph._nodes(Model.self)
        XCTAssertEqual(1, models?.count)
    }
    
    private func addClassv2(_ graph: Graph) {
        struct Model: Codable {
            let a: String
            let b: String
            let c: String
        }
        _ = graph._nodes(Model.self)
        graph._add(Model(a: "as", b: "bs", c: "cs"))
        let models = graph._nodes(Model.self)
        XCTAssertEqual(1, models?.count)
    }
}

private struct User: Codable {
    var name = "Lorem Ipsum"
    var age = 99
}

private struct UserWithId: Codable, Identifiable {
    var id = 0
    var name = "Some name"
    var age = 123
}

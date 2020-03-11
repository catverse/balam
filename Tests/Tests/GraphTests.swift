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
    
    func testAddNodeWithId() {
        let graph = Graph(url, queue: .main)
        try! FileManager.default.removeItem(at: url)
        graph._add(UserWithId())
        XCTAssertTrue(FileManager.default.fileExists(atPath: url.path))
    }
    
    func testAddWithIdNotUpdate() {
        let graph = Graph(url, queue: .main)
        var user = UserWithId()
        graph._add(user)
        user.name = "john test"
        graph._add(user)
        XCTAssertEqual(1, graph.nodes.first?.items.count)
        XCTAssertEqual("Some name", graph._nodes(UserWithId.self)?.first?.name)
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
    
    func testAddBatch() {
        let graph = Graph(url, queue: .main)
        try! FileManager.default.removeItem(at: url)
        var first = User()
        first.age = 22
        var second = User()
        second.age = 33
        var third = User()
        third.age = 18
        var fourth = User()
        fourth.age = 21
        graph._add([first, second, third, fourth])
        XCTAssertEqual(1, graph.nodes.count)
        graph.nodes.first.map {
            XCTAssertEqual("User", $0.name)
            XCTAssertEqual(4, $0.items.count)
        }
        XCTAssertTrue(FileManager.default.fileExists(atPath: url.path))
    }
    
    func testAddBatchWithId() {
        let graph = Graph(url, queue: .main)
        try! FileManager.default.removeItem(at: url)
        var first = UserWithId()
        first.id = 21
        first.age = 33
        var second = UserWithId()
        second.id = 33
        var third = UserWithId()
        third.id = 18
        var fourth = UserWithId()
        fourth.id = 21
        fourth.age = 99
        graph._add([first, second, third, fourth])
        XCTAssertEqual(1, graph.nodes.count)
        graph.nodes.first.map {
            XCTAssertEqual("UserWithId", $0.name)
            XCTAssertEqual(3, $0.items.count)
        }
        XCTAssertTrue(FileManager.default.fileExists(atPath: url.path))
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
        graph._add(UserWithId())
        var user = graph._nodes(UserWithId.self)!.first!
        user.name = "hello world"
        user.age = 456
        try! FileManager.default.removeItem(at: url)
        graph._update(user)
        let users = graph._nodes(UserWithId.self)
        XCTAssertEqual(1, users?.count)
        XCTAssertEqual("hello world", users?.first?.name)
        XCTAssertEqual(456, users?.first?.age)
        XCTAssertTrue(FileManager.default.fileExists(atPath: url.path))
    }
    
    func testRemoveNode() {
        let graph = Graph(url, queue: .main)
        graph._add(UserWithId())
        var user = graph._nodes(UserWithId.self)!.first!
        user.name = "hello world"
        user.age = 456
        try! FileManager.default.removeItem(at: url)
        graph._remove(user)
        XCTAssertNil(graph._nodes(UserWithId.self))
        XCTAssertTrue(FileManager.default.fileExists(atPath: url.path))
    }
    
    func testRemoveNodeWhenHave2() {
        let graph = Graph(url, queue: .main)
        var other = UserWithId()
        other.id = 1
        graph._add(other)
        graph._add(UserWithId())
        XCTAssertEqual(2, graph._nodes(UserWithId.self)?.count)
        graph._remove(other)
        XCTAssertEqual(1, graph._nodes(UserWithId.self)?.count)
    }
    
    func testRemoveWhen() {
        let graph = Graph(url, queue: .main)
        var first = User()
        first.age = 22
        var second = User()
        second.age = 33
        var third = User()
        third.name = "some"
        third.age = 22
        var fourth = User()
        fourth.age = 21
        var fifth = User()
        fifth.age = 15
        XCTAssertNil(graph._nodes(User.self))
        graph._add([first, second, third, fourth, fifth])
        XCTAssertEqual(5, graph._nodes(User.self)?.count)
        graph._remove(User.self) { $0.age == 22 }
        XCTAssertEqual(3, graph._nodes(User.self)?.count)
        XCTAssertEqual(1, graph.nodes.count)
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
    
    func testAddNotDuplicateWithId() {
        let graph = Graph(url, queue: .main)
        var user = UserWithId()
        graph._add(user)
        user.name = "another name"
        user.age = 321
        graph._add(user)
        XCTAssertEqual(1, graph._nodes(UserWithId.self)?.count)
    }
    
    func testAddNotDuplicate() {
        let graph = Graph(url, queue: .main)
        let user = User()
        graph._add(user)
        graph._add(user)
        XCTAssertEqual(1, graph._nodes(User.self)?.count)
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

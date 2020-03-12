import XCTest
@testable import Balam

@available(OSX 10.15, *) final class AddTests: XCTestCase {
    private var url: URL!
    
    override func setUp() {
        url = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("test")
        try? FileManager.default.removeItem(at: url)
    }
    
    override func tearDown() {
        try? FileManager.default.removeItem(at: url)
    }
    
    func testNode() {
        let graph = Graph(url, queue: .main)
        try! FileManager.default.removeItem(at: url)
        graph._add(User())
        XCTAssertEqual(1, graph.nodes.count)
        XCTAssertEqual("User", graph.nodes.first?.name)
        XCTAssertEqual(1, graph.nodes.first?.items.count)
        XCTAssertTrue(FileManager.default.fileExists(atPath: url.path))
    }
    
    func testAddAndRetrieve() {
        let graph = Graph(url, queue: .main)
        graph._add(User())
        let users = graph._nodes(User.self)
        XCTAssertEqual(1, users?.count)
        XCTAssertEqual("Lorem Ipsum", users?.first?.name)
        XCTAssertEqual(99, users?.first?.age)
    }
    
    func testId() {
        let graph = Graph(url, queue: .main)
        try! FileManager.default.removeItem(at: url)
        graph._add(UserWithId())
        XCTAssertTrue(FileManager.default.fileExists(atPath: url.path))
    }
    
    func testEquatable() {
        let graph = Graph(url, queue: .main)
        try! FileManager.default.removeItem(at: url)
        graph._add(UserEqual())
        XCTAssertTrue(FileManager.default.fileExists(atPath: url.path))
    }
    
    func testDuplicate() {
        let graph = Graph(url, queue: .main)
        let user = User()
        graph._add(user)
        graph._add(user)
        XCTAssertEqual(1, graph._nodes(User.self)?.count)
    }
    
    func testEquatableDuplicates() {
        let graph = Graph(url, queue: .main)
        var user = UserEqual()
        graph._add(user)
        graph._add(user)
        XCTAssertEqual(1, graph.nodes.first?.items.count)
        user.name = "lorem"
        graph._add(user)
        XCTAssertEqual(1, graph.nodes.first?.items.count)
        XCTAssertEqual("hello", graph._nodes(UserEqual.self)?.first?.name)
    }
    
    func testIdDuplicate() {
        let graph = Graph(url, queue: .main)
        var user = UserWithId()
        graph._add(user)
        user.name = "john test"
        graph._add(user)
        XCTAssertEqual(1, graph.nodes.first?.items.count)
        XCTAssertEqual("Some name", graph._nodes(UserWithId.self)?.first?.name)
    }
    
    func testThreeNodes() {
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

private struct UserEqual: Codable, Equatable {
    var id = 1
    var name = "hello"
    
    static func == (lhs: UserEqual, rhs: UserEqual) -> Bool {
        lhs.id == rhs.id
    }
}

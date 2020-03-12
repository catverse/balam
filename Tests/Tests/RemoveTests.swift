import XCTest
@testable import Balam

@available(OSX 10.15, *) final class RemoveTests: XCTestCase {
    private var url: URL!
    
    override func setUp() {
        url = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("test")
        try? FileManager.default.removeItem(at: url)
    }
    
    override func tearDown() {
        try? FileManager.default.removeItem(at: url)
    }
    
    func testRemove() {
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
    
    func testHave2() {
        let graph = Graph(url, queue: .main)
        var other = UserWithId()
        other.id = 1
        graph._add(other)
        graph._add(UserWithId())
        XCTAssertEqual(2, graph._nodes(UserWithId.self)?.count)
        graph._remove(other)
        XCTAssertEqual(1, graph._nodes(UserWithId.self)?.count)
    }
    
    func testWhen() {
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

import XCTest
@testable import Balam

@available(OSX 10.15, *) final class AddBatchTests: XCTestCase {
    private var url: URL!
    
    override func setUp() {
        url = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("test")
        try? FileManager.default.removeItem(at: url)
    }
    
    override func tearDown() {
        try? FileManager.default.removeItem(at: url)
    }
    
    func testBatch() {
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
    
    func testId() {
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
        XCTAssertEqual(33, graph._nodes(UserWithId.self)?.first { $0.id == 21 }?.age)
        XCTAssertTrue(FileManager.default.fileExists(atPath: url.path))
    }
    
    func testIdDuplicates() {
        let graph = Graph(url, queue: .main)
        var first = UserWithId()
        first.id = 21
        first.age = 33
        graph._add(first)
        first.age = 55
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
        XCTAssertEqual(33, graph._nodes(UserWithId.self)?.first { $0.id == 21 }?.age)
    }
    
    func testEquatable() {
        let graph = Graph(url, queue: .main)
        try! FileManager.default.removeItem(at: url)
        var first = UserEqual()
        first.id = 21
        first.name = "world"
        var second = UserEqual()
        second.id = 21
        second.name = "hello"
        graph._add([first, second])
        XCTAssertEqual(1, graph.nodes.count)
        graph.nodes.first.map {
            XCTAssertEqual("UserEqual", $0.name)
            XCTAssertEqual(1, $0.items.count)
        }
        XCTAssertEqual("world", graph._nodes(UserEqual.self)?.first { $0.id == 21 }?.name)
        XCTAssertTrue(FileManager.default.fileExists(atPath: url.path))
    }
    
    func testEquatableDuplicates() {
        let graph = Graph(url, queue: .main)
        var first = UserEqual()
        first.id = 21
        first.name = "world"
        var second = UserEqual()
        second.id = 22
        graph._add(first)
        first.name = "lorem"
        graph._add([first, second])
        XCTAssertEqual(1, graph.nodes.count)
        graph.nodes.first.map {
            XCTAssertEqual("UserEqual", $0.name)
            XCTAssertEqual(2, $0.items.count)
        }
        XCTAssertEqual("world", graph._nodes(UserEqual.self)?.first { $0.id == 21 }?.name)
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

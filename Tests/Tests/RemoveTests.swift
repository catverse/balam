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
    /*
    func testRemove() {
        let graph = Graph(url, queue: .main)
        graph._add(UserId())
        var user = graph._nodes(UserId.self)!.first!
        user.name = "hello world"
        user.id = 456
        try! FileManager.default.removeItem(at: url)
        graph._remove(user)
        XCTAssertNil(graph._nodes(UserId.self))
        XCTAssertTrue(FileManager.default.fileExists(atPath: url.path))
    }
    
    func testHave2() {
        let graph = Graph(url, queue: .main)
        var other = UserId()
        other.id = 1
        graph._add(other)
        graph._add(UserId())
        XCTAssertEqual(2, graph._nodes(UserId.self)?.count)
        graph._remove(other)
        XCTAssertEqual(1, graph._nodes(UserId.self)?.count)
    }
    
    func testWhen() {
        let graph = Graph(url, queue: .main)
        var first = User()
        first.id = 22
        var second = User()
        second.id = 33
        var third = User()
        third.name = "some"
        third.id = 22
        var fourth = User()
        fourth.id = 21
        var fifth = User()
        fifth.id = 15
        XCTAssertNil(graph._nodes(User.self))
        graph._add([first, second, third, fourth, fifth])
        XCTAssertEqual(5, graph._nodes(User.self)?.count)
        graph._remove(User.self) { $0.id == 22 }
        XCTAssertEqual(3, graph._nodes(User.self)?.count)
        XCTAssertEqual(1, graph.items.count)
    }*/
}

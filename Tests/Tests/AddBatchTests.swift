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
    /*
    func testBatch() {
        let graph = Graph(url, queue: .main)
        try! FileManager.default.removeItem(at: url)
        var first = User()
        first.id = 22
        var second = User()
        second.id = 33
        var third = User()
        third.id = 18
        var fourth = User()
        fourth.id = 21
        graph._add([first, second, third, fourth])
        XCTAssertEqual(1, graph.items.count)
        graph.items.first.map {
            XCTAssertEqual("User", $0.name)
            XCTAssertEqual(4, $0.items.count)
        }
        XCTAssertTrue(FileManager.default.fileExists(atPath: url.path))
    }
    
    func testId() {
        let graph = Graph(url, queue: .main)
        try! FileManager.default.removeItem(at: url)
        var first = UserId()
        first.id = 21
        first.id = 33
        var second = UserId()
        second.id = 33
        var third = UserId()
        third.id = 18
        var fourth = UserId()
        fourth.id = 21
        fourth.id = 99
        graph._add([first, second, third, fourth])
        XCTAssertEqual(1, graph.items.count)
        graph.items.first.map {
            XCTAssertEqual("UserId", $0.name)
            XCTAssertEqual(3, $0.items.count)
        }
        XCTAssertEqual(33, graph._nodes(UserId.self)?.first { $0.id == 21 }?.id)
        XCTAssertTrue(FileManager.default.fileExists(atPath: url.path))
    }
    
    func testIdDuplicates() {
        let graph = Graph(url, queue: .main)
        var first = UserId()
        first.id = 21
        first.id = 33
        graph._add(first)
        first.id = 55
        var second = UserId()
        second.id = 33
        var third = UserId()
        third.id = 18
        var fourth = UserId()
        fourth.id = 21
        fourth.id = 99
        graph._add([first, second, third, fourth])
        XCTAssertEqual(1, graph.items.count)
        graph.items.first.map {
            XCTAssertEqual("UserId", $0.name)
            XCTAssertEqual(3, $0.items.count)
        }
        XCTAssertEqual(33, graph._nodes(UserId.self)?.first { $0.id == 21 }?.id)
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
        XCTAssertEqual(1, graph.items.count)
        graph.items.first.map {
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
        XCTAssertEqual(1, graph.items.count)
        graph.items.first.map {
            XCTAssertEqual("UserEqual", $0.name)
            XCTAssertEqual(2, $0.items.count)
        }
        XCTAssertEqual("world", graph._nodes(UserEqual.self)?.first { $0.id == 21 }?.name)
    }
 */
}

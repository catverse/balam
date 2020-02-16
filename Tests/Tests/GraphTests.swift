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
    
    func testSave() {
        let expect = expectation(description: "")
        let graph = Graph(url)
        graph.saved.sink {
            XCTAssertTrue(FileManager.default.fileExists(atPath: self.url.path))
            expect.fulfill()
        }.store(in: &subs)
        graph.save()
        waitForExpectations(timeout: 1)
    }
    
    func testAddNode() {
        let expect = expectation(description: "")
        let graph = Graph(url)
        graph.saved.sink {
            expect.fulfill()
        }.store(in: &subs)
        graph.add(User())
        waitForExpectations(timeout: 1) { _ in
            XCTAssertEqual(1, graph.nodes.count)
            XCTAssertEqual("User", graph.nodes.first?.name)
            XCTAssertEqual(.string, graph.nodes.first?.description["name"])
            XCTAssertEqual(.int, graph.nodes.first?.description["age"])
            XCTAssertEqual(1, graph.nodes.first?.items.count)
        }
    }
    
    func testAddThreeNodes() {
        let expect = expectation(description: "")
        expect.expectedFulfillmentCount = 3
        let graph = Graph(url)
        graph.saved.sink {
            expect.fulfill()
        }.store(in: &subs)
        var last = User()
        last.name = "Ipsum Lorem"
        last.age = 33
        graph.add(User())
        graph.add(User())
        graph.add(last)
        waitForExpectations(timeout: 1) { _ in
            XCTAssertEqual(1, graph.nodes.count)
            XCTAssertEqual("User", graph.nodes.first?.name)
            XCTAssertEqual(3, graph.nodes.first?.items.count)
        }
    }
}

private struct User: Codable {
    var name = "Lorem Ipsum"
    var age = 99
}

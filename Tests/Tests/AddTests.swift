import XCTest
import Combine
@testable import Balam

@available(OSX 10.15, *) final class AddTests: XCTestCase {
    private var url: URL!
    private var subs: Set<AnyCancellable>!
    
    override func setUp() {
        url = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("test")
        subs = .init()
        try? FileManager.default.removeItem(at: url)
        try? FileManager.default.removeItem(at: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("test.balam"))
    }
    
    override func tearDown() {
        try? FileManager.default.removeItem(at: url)
        try? FileManager.default.removeItem(at: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("test.balam"))
    }
    
    func testAdd() {
        let expect = expectation(description: "")
        Balam.graph(url).sink { graph in
            try! FileManager.default.removeItem(at: self.url)
            graph.add(User())
            graph.nodes(User.self).sink {
                XCTAssertEqual(1, graph.items.count)
                XCTAssertEqual("User", graph.items.first?.name)
                XCTAssertEqual(1, $0.count)
                XCTAssertTrue(FileManager.default.fileExists(atPath: self.url.path))
                expect.fulfill()
            }.store(in: &self.subs)
        }.store(in: &subs)
        waitForExpectations(timeout: 1)
    }
    
    func testDuplicate() {
        let expect = expectation(description: "")
        Balam.graph(url).sink {
            $0.add(User())
            $0.add(User())
            $0.nodes(User.self).sink {
                XCTAssertEqual(1, $0.count)
                expect.fulfill()
            }.store(in: &self.subs)
        }.store(in: &subs)
        waitForExpectations(timeout: 1)
    }
    
    /*
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
        XCTAssertEqual(1, graph.items.first?.items.count)
        user.name = "lorem"
        graph._add(user)
        XCTAssertEqual(1, graph.items.first?.items.count)
        XCTAssertEqual("hello", graph._nodes(UserEqual.self)?.first?.name)
    }
    
    func testIdDuplicate() {
        let graph = Graph(url, queue: .main)
        var user = UserWithId()
        graph._add(user)
        user.name = "john test"
        graph._add(user)
        XCTAssertEqual(1, graph.items.first?.items.count)
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
        XCTAssertEqual(1, graph.items.count)
        graph.items.forEach {
            XCTAssertEqual("User", $0.name)
            XCTAssertEqual(3, $0.items.count)
        }
    }*/
}

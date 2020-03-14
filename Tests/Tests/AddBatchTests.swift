import XCTest
import Combine
@testable import Balam

@available(OSX 10.15, *) final class AddBatchTests: XCTestCase {
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
            graph.add([User()])
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
            $0.add([User(), User()])
            $0.nodes(User.self).sink {
                XCTAssertEqual(1, $0.count)
                expect.fulfill()
            }.store(in: &self.subs)
        }.store(in: &subs)
        waitForExpectations(timeout: 1)
    }
    
    func testDifference() {
        let expect = expectation(description: "")
        let userA = User()
        var userB = User()
        userB.name = "sue"
        Balam.graph(url).sink {
            $0.add([userA, userB])
            $0.nodes(User.self).sink {
                XCTAssertEqual(2, $0.count)
                expect.fulfill()
            }.store(in: &self.subs)
        }.store(in: &subs)
        waitForExpectations(timeout: 1)
    }
    
    func testEquatable() {
        let expect = expectation(description: "")
        let userA = UserEqual()
        var userB = UserEqual()
        userB.name = "sue"
        Balam.graph(url).sink {
            try! FileManager.default.removeItem(at: self.url)
            $0.add([userA, userB])
            $0.nodes(UserEqual.self).sink {
                XCTAssertEqual(1, $0.count)
                XCTAssertEqual("", $0.first?.name)
                XCTAssertTrue(FileManager.default.fileExists(atPath: self.url.path))
                expect.fulfill()
            }.store(in: &self.subs)
        }.store(in: &subs)
        waitForExpectations(timeout: 1)
    }
    
    func testId() {
        let expect = expectation(description: "")
        let userA = UserId()
        var userB = UserId()
        userB.name = "sue"
        Balam.graph(url).sink {
            try! FileManager.default.removeItem(at: self.url)
            $0.add([userA, userB])
            $0.nodes(UserId.self).sink {
                XCTAssertEqual(1, $0.count)
                XCTAssertEqual("", $0.first?.name)
                XCTAssertTrue(FileManager.default.fileExists(atPath: self.url.path))
                expect.fulfill()
            }.store(in: &self.subs)
        }.store(in: &subs)
        waitForExpectations(timeout: 1)
    }
    
    func testEqualtableAndId() {
        let expect = expectation(description: "")
        let userA = UserEqualId()
        var userB = UserEqualId()
        userB.last = "sue"
        Balam.graph(url).sink {
            try! FileManager.default.removeItem(at: self.url)
            $0.add([userA, userB])
            $0.nodes(UserEqualId.self).sink {
                XCTAssertEqual(1, $0.count)
                XCTAssertEqual("", $0.first?.last)
                XCTAssertTrue(FileManager.default.fileExists(atPath: self.url.path))
                expect.fulfill()
            }.store(in: &self.subs)
        }.store(in: &subs)
        waitForExpectations(timeout: 1)
    }
}

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
    
    func testDifference() {
        let expect = expectation(description: "")
        var user = User()
        Balam.graph(url).sink {
            $0.add(user)
            user.name = "sue"
            $0.add(user)
            $0.nodes(User.self).sink {
                XCTAssertEqual(2, $0.count)
                expect.fulfill()
            }.store(in: &self.subs)
        }.store(in: &subs)
        waitForExpectations(timeout: 1)
    }
    
    func testEquatable() {
        let expect = expectation(description: "")
        var user = UserEqual()
        Balam.graph(url).sink { graph in
            graph.add(user)
            graph.nodes(UserEqual.self).sink { _ in
                user.name = "sue"
                try! FileManager.default.removeItem(at: self.url)
                graph.add(user)
                graph.nodes(UserEqual.self).sink {
                    XCTAssertEqual(1, $0.count)
                    XCTAssertEqual("", $0.first?.name)
                    XCTAssertTrue(FileManager.default.fileExists(atPath: self.url.path))
                    expect.fulfill()
                }.store(in: &self.subs)
            }.store(in: &self.subs)
        }.store(in: &subs)
        waitForExpectations(timeout: 1)
    }
    
    func testId() {
        let expect = expectation(description: "")
        var user = UserId()
        Balam.graph(url).sink { graph in
            graph.add(user)
            graph.nodes(UserId.self).sink { _ in
                user.name = "sue"
                try! FileManager.default.removeItem(at: self.url)
                graph.add(user)
                graph.nodes(UserId.self).sink {
                    XCTAssertEqual(1, $0.count)
                    XCTAssertEqual("", $0.first?.name)
                    XCTAssertTrue(FileManager.default.fileExists(atPath: self.url.path))
                    expect.fulfill()
                }.store(in: &self.subs)
            }.store(in: &self.subs)
        }.store(in: &subs)
        waitForExpectations(timeout: 1)
    }
    
    func testEquatableAndId() {
        let expect = expectation(description: "")
        var user = UserEqualId()
        Balam.graph(url).sink { graph in
            graph.add(user)
            graph.nodes(UserEqualId.self).sink { _ in
                user.last = "sue"
                try! FileManager.default.removeItem(at: self.url)
                graph.add(user)
                graph.nodes(UserEqualId.self).sink {
                    XCTAssertEqual(1, $0.count)
                    XCTAssertEqual("", $0.first?.last)
                    XCTAssertTrue(FileManager.default.fileExists(atPath: self.url.path))
                    expect.fulfill()
                }.store(in: &self.subs)
            }.store(in: &self.subs)
        }.store(in: &subs)
        waitForExpectations(timeout: 1)
    }
    
    func testDifferentEquatable() {
        let expect = expectation(description: "")
        var user = UserEqualId()
        Balam.graph(url).sink {
            $0.add(user)
            user.name = "sue"
            $0.add(user)
            $0.nodes(UserEqualId.self).sink {
                XCTAssertEqual(2, $0.count)
                expect.fulfill()
            }.store(in: &self.subs)
        }.store(in: &subs)
        waitForExpectations(timeout: 1)
    }
    
    func testDifferentId() {
        let expect = expectation(description: "")
        var user = UserEqualId()
        Balam.graph(url).sink {
            $0.add(user)
            user.id = 2
            $0.add(user)
            $0.nodes(UserEqualId.self).sink {
                XCTAssertEqual(2, $0.count)
                expect.fulfill()
            }.store(in: &self.subs)
        }.store(in: &subs)
        waitForExpectations(timeout: 1)
    }
}

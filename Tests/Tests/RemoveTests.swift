import XCTest
import Combine
@testable import Balam

@available(OSX 10.15, *) final class RemoveTests: XCTestCase {
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
    
    func testSimple() {
        let expect = expectation(description: "")
        Balam.graph(url).sink { graph in
            graph.add(User())
            graph.nodes(User.self).sink {
                XCTAssertFalse($0.isEmpty)
                try! FileManager.default.removeItem(at: self.url)
                graph.remove(User())
                graph.nodes(User.self).sink {
                    XCTAssertTrue($0.isEmpty)
                    XCTAssertTrue(FileManager.default.fileExists(atPath: self.url.path))
                    expect.fulfill()
                }.store(in: &self.subs)
            }.store(in: &self.subs)
        }.store(in: &subs)
        waitForExpectations(timeout: 1)
    }
    
    func testEquatable() {
        let expect = expectation(description: "")
        var user = UserEqual()
        Balam.graph(url).sink { graph in
            graph.add(user)
            graph.nodes(UserEqual.self).sink {
                XCTAssertFalse($0.isEmpty)
                user.name = "some"
                try! FileManager.default.removeItem(at: self.url)
                graph.remove(user)
                graph.nodes(UserEqual.self).sink {
                    XCTAssertTrue($0.isEmpty)
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
            graph.nodes(UserId.self).sink {
                XCTAssertFalse($0.isEmpty)
                user.name = "some"
                try! FileManager.default.removeItem(at: self.url)
                graph.remove(user)
                graph.nodes(UserId.self).sink {
                    XCTAssertTrue($0.isEmpty)
                    XCTAssertTrue(FileManager.default.fileExists(atPath: self.url.path))
                    expect.fulfill()
                }.store(in: &self.subs)
            }.store(in: &self.subs)
        }.store(in: &subs)
        waitForExpectations(timeout: 1)
    }
    
    func testEqualtableAndId() {
        let expect = expectation(description: "")
        var user = UserEqualId()
        Balam.graph(url).sink { graph in
            graph.add(user)
            user.name = "some"
            user.last = "sue"
            graph.remove(user)
            graph.nodes(UserEqualId.self).sink {
                XCTAssertFalse($0.isEmpty)
                user.id = 2
                user.name = ""
                graph.remove(user)
                graph.nodes(UserEqualId.self).sink {
                    XCTAssertFalse($0.isEmpty)
                    user.id = 1
                    try! FileManager.default.removeItem(at: self.url)
                    graph.remove(user)
                    graph.nodes(UserEqualId.self).sink {
                        XCTAssertTrue($0.isEmpty)
                        XCTAssertTrue(FileManager.default.fileExists(atPath: self.url.path))
                        expect.fulfill()
                    }.store(in: &self.subs)
                }.store(in: &self.subs)
            }.store(in: &self.subs)
        }.store(in: &subs)
        waitForExpectations(timeout: 1)
    }
    
    func testWhen() {
        let expect = expectation(description: "")
        var userA = User()
        userA.name = "a"
        var userB = User()
        userB.name = "b"
        var userC = User()
        userC.name = "c"
        Balam.graph(url).sink { graph in
            graph.add([userA, userB, userC])
            graph.nodes(User.self).sink {
                XCTAssertEqual(3, $0.count)
                try! FileManager.default.removeItem(at: self.url)
                graph.remove(User.self) { $0.name != "b" }
                graph.nodes(User.self).sink {
                    XCTAssertEqual(1, $0.count)
                    XCTAssertNotNil($0.first { $0.name == "b" })
                    XCTAssertTrue(FileManager.default.fileExists(atPath: self.url.path))
                    expect.fulfill()
                }.store(in: &self.subs)
            }.store(in: &self.subs)
        }.store(in: &subs)
        waitForExpectations(timeout: 1)
    }
}

import XCTest
import Combine
@testable import Balam

@available(OSX 10.15, *) final class RemoveTests: XCTestCase {
    private var url: URL!
    private var subs: Set<AnyCancellable>!
    private var balam: Balam!
    
    override func setUp() {
        url = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("test")
        subs = .init()
        try? FileManager.default.removeItem(at: url)
        try? FileManager.default.removeItem(at: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("test.balam"))
        balam = .init(url)
    }
    
    override func tearDown() {
        try? FileManager.default.removeItem(at: url)
        try? FileManager.default.removeItem(at: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("test.balam"))
    }
    
    func testSimple() {
        let expect = expectation(description: "")
        balam.add(User())
        balam.nodes(User.self).sink {
            XCTAssertFalse($0.isEmpty)
            try! FileManager.default.removeItem(at: self.url)
            self.balam.remove(User())
            self.balam.nodes(User.self).sink {
                XCTAssertTrue($0.isEmpty)
                XCTAssertTrue(FileManager.default.fileExists(atPath: self.url.path))
                expect.fulfill()
            }.store(in: &self.subs)
        }.store(in: &subs)
        waitForExpectations(timeout: 1)
    }
    
    func testEquatable() {
        let expect = expectation(description: "")
        var user = UserEqual()
        balam.add(user)
        balam.nodes(UserEqual.self).sink {
            XCTAssertFalse($0.isEmpty)
            user.name = "some"
            try! FileManager.default.removeItem(at: self.url)
            self.balam.remove(user)
            self.balam.nodes(UserEqual.self).sink {
                XCTAssertTrue($0.isEmpty)
                XCTAssertTrue(FileManager.default.fileExists(atPath: self.url.path))
                expect.fulfill()
            }.store(in: &self.subs)
        }.store(in: &subs)
        waitForExpectations(timeout: 1)
    }
    
    func testId() {
        let expect = expectation(description: "")
        var user = UserId()
        balam.add(user)
        balam.nodes(UserId.self).sink {
            XCTAssertFalse($0.isEmpty)
            user.name = "some"
            try! FileManager.default.removeItem(at: self.url)
            self.balam.remove(user)
            self.balam.nodes(UserId.self).sink {
                XCTAssertTrue($0.isEmpty)
                XCTAssertTrue(FileManager.default.fileExists(atPath: self.url.path))
                expect.fulfill()
            }.store(in: &self.subs)
        }.store(in: &subs)
        waitForExpectations(timeout: 1)
    }
    
    func testEqualtableAndId() {
        let expect = expectation(description: "")
        var user = UserEqualId()
        balam.add(user)
        user.name = "some"
        user.last = "sue"
        self.balam.remove(user)
        balam.nodes(UserEqualId.self).sink {
            XCTAssertFalse($0.isEmpty)
            user.id = 2
            user.name = ""
            self.balam.remove(user)
            self.balam.nodes(UserEqualId.self).sink {
                XCTAssertFalse($0.isEmpty)
                user.id = 1
                try! FileManager.default.removeItem(at: self.url)
                self.balam.remove(user)
                self.balam.nodes(UserEqualId.self).sink {
                    XCTAssertTrue($0.isEmpty)
                    XCTAssertTrue(FileManager.default.fileExists(atPath: self.url.path))
                    expect.fulfill()
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
        balam.add([userA, userB, userC])
        balam.nodes(User.self).sink {
            XCTAssertEqual(3, $0.count)
            try! FileManager.default.removeItem(at: self.url)
            self.balam.remove(User.self) { $0.name != "b" }
            self.balam.nodes(User.self).sink {
                XCTAssertEqual(1, $0.count)
                XCTAssertNotNil($0.first { $0.name == "b" })
                XCTAssertTrue(FileManager.default.fileExists(atPath: self.url.path))
                expect.fulfill()
            }.store(in: &self.subs)
        }.store(in: &subs)
        waitForExpectations(timeout: 1)
    }
}

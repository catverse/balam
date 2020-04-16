import XCTest
import Combine
@testable import Balam

final class AddTests: XCTestCase {
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
    
    func testAdd() {
        let expect = expectation(description: "")
        balam.nodes(User.self).sink { _ in
            try! FileManager.default.removeItem(at: self.url)
            self.balam.add(User())
            self.balam.nodes(User.self).sink {
                XCTAssertEqual(1, self.balam.items.count)
                XCTAssertEqual("User", self.balam.items.first?.name)
                XCTAssertEqual(1, $0.count)
                XCTAssertTrue(FileManager.default.fileExists(atPath: self.url.path))
                expect.fulfill()
            }.store(in: &self.subs)
        }.store(in: &subs)
        waitForExpectations(timeout: 1)
    }
    
    func testDuplicate() {
        let expect = expectation(description: "")
        balam.add(User())
        balam.add(User())
        balam.nodes(User.self).sink {
            XCTAssertEqual(1, $0.count)
            expect.fulfill()
        }.store(in: &subs)
        waitForExpectations(timeout: 1)
    }
    
    func testDifference() {
        let expect = expectation(description: "")
        var user = User()
        balam.add(user)
        user.name = "sue"
        balam.add(user)
        balam.nodes(User.self).sink {
            XCTAssertEqual(2, $0.count)
            expect.fulfill()
        }.store(in: &subs)
        waitForExpectations(timeout: 1)
    }
    
    func testEquatable() {
        let expect = expectation(description: "")
        var user = UserEqual()
        balam.add(user)
        balam.nodes(UserEqual.self).sink { _ in
            user.name = "sue"
            try! FileManager.default.removeItem(at: self.url)
            self.balam.add(user)
            self.balam.nodes(UserEqual.self).sink {
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
        var user = UserId()
        balam.add(user)
        balam.nodes(UserId.self).sink { _ in
            user.name = "sue"
            try! FileManager.default.removeItem(at: self.url)
            self.balam.add(user)
            self.balam.nodes(UserId.self).sink {
                XCTAssertEqual(1, $0.count)
                XCTAssertEqual("", $0.first?.name)
                XCTAssertTrue(FileManager.default.fileExists(atPath: self.url.path))
                expect.fulfill()
            }.store(in: &self.subs)
        }.store(in: &subs)
        waitForExpectations(timeout: 1)
    }
    
    func testEquatableAndId() {
        let expect = expectation(description: "")
        var user = UserEqualId()
        balam.add(user)
        balam.nodes(UserEqualId.self).sink { _ in
            user.last = "sue"
            try! FileManager.default.removeItem(at: self.url)
            self.balam.add(user)
            self.balam.nodes(UserEqualId.self).sink {
                XCTAssertEqual(1, $0.count)
                XCTAssertEqual("", $0.first?.last)
                XCTAssertTrue(FileManager.default.fileExists(atPath: self.url.path))
                expect.fulfill()
            }.store(in: &self.subs)
        }.store(in: &subs)
        waitForExpectations(timeout: 1)
    }
    
    func testDifferentEquatable() {
        let expect = expectation(description: "")
        var user = UserEqualId()
        balam.add(user)
        user.name = "sue"
        balam.add(user)
        balam.nodes(UserEqualId.self).sink {
            XCTAssertEqual(2, $0.count)
            expect.fulfill()
        }.store(in: &subs)
        waitForExpectations(timeout: 1)
    }
    
    func testDifferentId() {
        let expect = expectation(description: "")
        var user = UserEqualId()
        balam.add(user)
        user.id = 2
        balam.add(user)
        balam.nodes(UserEqualId.self).sink {
            XCTAssertEqual(2, $0.count)
            expect.fulfill()
        }.store(in: &subs)
        waitForExpectations(timeout: 1)
    }
}

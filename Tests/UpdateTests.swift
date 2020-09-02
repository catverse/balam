import XCTest
import Combine
@testable import Balam

final class UpdateTests: XCTestCase {
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
    
    func testNonExisiting() {
        let expect = expectation(description: "")
        balam.update(UserEqual())
        balam.nodes(UserEqual.self).sink {
            XCTAssertTrue($0.isEmpty)
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
            self.balam.update(user)
            self.balam.nodes(UserEqual.self).sink {
                XCTAssertEqual(1, $0.count)
                XCTAssertEqual("sue", $0.first?.name)
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
            self.balam.update(user)
            self.balam.nodes(UserId.self).sink {
                XCTAssertEqual(1, $0.count)
                XCTAssertEqual("sue", $0.first?.name)
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
        balam.update(user)
        balam.nodes(UserEqualId.self).sink {
            XCTAssertEqual("", $0.first?.last)
            user.id = 2
            user.name = ""
            self.balam.update(user)
            self.balam.nodes(UserEqualId.self).sink {
                XCTAssertEqual("", $0.first?.last)
                user.id = 1
                try! FileManager.default.removeItem(at: self.url)
                self.balam.update(user)
                self.balam.nodes(UserEqualId.self).sink {
                    XCTAssertEqual(1, $0.count)
                    XCTAssertEqual("sue", $0.first?.last)
                    XCTAssertTrue(FileManager.default.fileExists(atPath: self.url.path))
                    expect.fulfill()
                }.store(in: &self.subs)
            }.store(in: &self.subs)
        }.store(in: &subs)
        waitForExpectations(timeout: 1)
    }
    
    func testWith() {
        let expect = expectation(description: "")
        balam.add([User(), User()])
        balam.nodes(User.self).sink { _ in
            try! FileManager.default.removeItem(at: self.url)
            self.balam.update(User.self) {
                $0.name = "updated"
            }
            self.balam.nodes(User.self).sink {
                XCTAssertNil($0.first { $0.name != "updated" })
                XCTAssertTrue(FileManager.default.fileExists(atPath: self.url.path))
                expect.fulfill()
            }.store(in: &self.subs)
        }.store(in: &subs)
        waitForExpectations(timeout: 1)
    }
    
    func testWithOptionals() {
        let expect = expectation(description: "")
        balam.add(Out())
        balam.nodes(Out.self).sink { _ in
            var out = Out()
            out.items.append(.init(value: true))
            self.balam.update(out)
            self.balam.nodes(Out.self).sink {
                XCTAssertEqual(1, $0.count)
                XCTAssertEqual(1, $0.first?.items.count)
                expect.fulfill()
            }.store(in: &self.subs)
        }.store(in: &subs)
        waitForExpectations(timeout: 1)
    }
}

private struct Out: Codable, Equatable {
    struct In: Codable {
        let value: Bool?
    }
    
    var items = [In]()
    
    func hash(into: inout Hasher) { }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        true
    }
}

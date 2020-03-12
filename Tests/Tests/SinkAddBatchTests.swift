import XCTest
import Combine
import Balam

@available(OSX 10.15, *) final class SinkAddBatchTests: XCTestCase {
    private var url: URL!
    private var subs: Set<AnyCancellable>!
    
    override func setUp() {
        subs = .init()
        url = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("test")
        try? FileManager.default.removeItem(at: url)
    }
    
    override func tearDown() {
        try? FileManager.default.removeItem(at: url)
        try? FileManager.default.removeItem(at: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("test.balam"))
    }
    
    func testDuplicates() {
        let expect = expectation(description: "")
        Balam.graph(url).sink {
            $0.add(User())
            $0.add([User(), User()])
            $0.nodes(User.self).sink {
                XCTAssertEqual(1, $0.count)
                expect.fulfill()
            }.store(in: &self.subs)
        }.store(in: &subs)
        waitForExpectations(timeout: 1)
    }
    
    func testIdDuplicates() {
        let expect = expectation(description: "")
        var user1 = UserId()
        user1.id = 1
        user1.name = "hello"
        var user2 = UserId()
        user2.id = 2
        var user3 = UserId()
        user3.id = 1
        user3.name = "world"
        Balam.graph(url).sink {
            $0.add(user3)
            $0.add([user1, user2, user3])
            $0.nodes(UserId.self).sink {
                XCTAssertEqual(2, $0.count)
                XCTAssertEqual("world", $0.first { $0.id == 1 }?.name)
                expect.fulfill()
            }.store(in: &self.subs)
        }.store(in: &subs)
        waitForExpectations(timeout: 1)
    }
    
    func testEqualsDuplicates() {
        let expect = expectation(description: "")
        var user1 = UserEqual()
        user1.id = 1
        user1.name = "hello"
        var user2 = UserEqual()
        user2.id = 2
        var user3 = UserEqual()
        user3.id = 1
        user3.name = "world"
        Balam.graph(url).sink {
            $0.add(user3)
            $0.add([user1, user2, user3])
            $0.nodes(UserEqual.self).sink {
                XCTAssertEqual(2, $0.count)
                XCTAssertEqual("world", $0.first { $0.id == 1 }?.name)
                expect.fulfill()
            }.store(in: &self.subs)
        }.store(in: &subs)
        waitForExpectations(timeout: 1)
    }
    
    func testEqualsAndId() {
        let expect = expectation(description: "")
        var user1 = UserEqualId()
        user1.id = 1
        user1.name = "hello"
        user1.last = "ipsum"
        var user2 = UserEqualId()
        user2.id = 2
        user2.name = "hello"
        var user3 = UserEqualId()
        user3.id = 1
        user3.name = "world"
        var user4 = UserEqualId()
        user4.id = 2
        user4.name = "world"
        var user5 = UserEqualId()
        user5.id = 1
        user5.name = "hello"
        user5.last = "test"
        Balam.graph(url).sink {
            $0.add([user1, user2, user3, user4, user5])
            $0.nodes(UserEqualId.self).sink {
                XCTAssertEqual(4, $0.count)
                XCTAssertEqual("ipsum", $0.first { $0.id == 1 && $0.name == "hello" }?.last)
                expect.fulfill()
            }.store(in: &self.subs)
        }.store(in: &subs)
        waitForExpectations(timeout: 1)
    }
}

private struct User: Codable {
    var name = "lorem"
    var age = 99
}

private struct UserId: Codable, Identifiable {
    var id = 0
    var name = "ipsum"
}

private struct UserEqual: Codable, Equatable {
    var id = 1
    var name = "hello"
    
    static func == (lhs: UserEqual, rhs: UserEqual) -> Bool {
        lhs.id == rhs.id
    }
}

private struct UserEqualId: Codable, Equatable, Identifiable {
    var id = 1
    var name = "world"
    var last = ""
    
    static func == (lhs: UserEqualId, rhs: UserEqualId) -> Bool {
        lhs.name == rhs.name
    }
}

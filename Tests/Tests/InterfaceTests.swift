import XCTest
import Combine
import Balam

@available(OSX 10.15, *) final class InterfaceTests: XCTestCase {
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
    
    func testAddNotDuplicates() {
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
    
    func testAddWithChange() {
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
    
    func testAddEquatableNoDuplicates() {
        let expect = expectation(description: "")
        var user = UserEqual()
        Balam.graph(url).sink {
            $0.add(user)
            user.name = "sue"
            $0.add(user)
            $0.nodes(UserEqual.self).sink {
                XCTAssertEqual(1, $0.count)
                expect.fulfill()
            }.store(in: &self.subs)
        }.store(in: &subs)
        waitForExpectations(timeout: 1)
    }
    
    func testAddIdNoDuplicates() {
        let expect = expectation(description: "")
        var user = UserId()
        Balam.graph(url).sink {
            $0.add(user)
            user.name = "sue"
            $0.add(user)
            $0.nodes(UserId.self).sink {
                XCTAssertEqual(1, $0.count)
                expect.fulfill()
            }.store(in: &self.subs)
        }.store(in: &subs)
        waitForExpectations(timeout: 1)
    }
    
    func testAddBatchNotDuplicates() {
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
    
    func testAddBathWithIdNotDuplicates() {
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
    
    func testAddBathEqualsNotDuplicates() {
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

import XCTest
import Combine
@testable import Balam

final class GetTests: XCTestCase {
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
    
    func testCodable() {
        let expect = expectation(description: "")
        balam.add(User())
        DispatchQueue.global(qos: .background).async {
            self.balam.nodes(User.self).sink { _ in
                XCTAssertEqual(.main, Thread.current)
                expect.fulfill()
            }.store(in: &self.subs)
        }
        waitForExpectations(timeout: 1)
    }
    
    func testEquatable() {
        let expect = expectation(description: "")
        let userA = UserEqual()
        var userB = UserEqual()
        userB.id = 2
        var userC = UserEqual()
        userC.id = 3
        balam.add([userA, userB, userC])
        DispatchQueue.global(qos: .background).async {
            self.balam.nodes(UserEqual.self) { $0.id != 2 }.sink {
                XCTAssertEqual(.main, Thread.current)
                XCTAssertEqual(2, $0.count)
                expect.fulfill()
            }.store(in: &self.subs)
        }
        waitForExpectations(timeout: 1)
    }
    
    func testIdentifiable() {
        let expect = expectation(description: "")
        let userA = UserId()
        var userB = UserId()
        userB.id = 2
        var userC = UserId()
        userC.id = 3
        balam.add([userA, userB, userC])
        DispatchQueue.global(qos: .background).async {
            self.balam.nodes(UserId.self) { $0.id == 2 }.sink {
                XCTAssertEqual(1, $0.count)
                XCTAssertEqual(2, $0.first?.id)
                expect.fulfill()
            }.store(in: &self.subs)
        }
        waitForExpectations(timeout: 1)
    }
}

import XCTest
import Combine
@testable import Balam

final class BalamTests: XCTestCase {
    private var url: URL!
    private var subs: Set<AnyCancellable>!
    
    override func setUp() {
        subs = .init()
        url = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("test")
        try? FileManager.default.removeItem(at: url)
        try? FileManager.default.removeItem(at: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("test.balam"))
    }
    
    override func tearDown() {
        try? FileManager.default.removeItem(at: url)
        try? FileManager.default.removeItem(at: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("test.balam"))
    }
    
    func testCreate() {
        let expect = expectation(description: "")
        Balam(url).describe().sink { _ in
            XCTAssertTrue(FileManager.default.fileExists(atPath: self.url.path))
            expect.fulfill()
        }.store(in: &subs)
        waitForExpectations(timeout: 1)
    }
    
    func testLoad() {
        let expect = expectation(description: "")
        let balam = Balam(url)
        var user = User()
        user.name = "lorem"
        balam.add(user)
        balam.nodes(User.self).sink { _ in
            let other = Balam(self.url)
            other.nodes(User.self).sink {
                XCTAssertEqual(1, $0.count)
                XCTAssertNotNil($0.first { $0.name == "lorem" })
                expect.fulfill()
            }.store(in: &self.subs)
        }.store(in: &subs)
        waitForExpectations(timeout: 1)
    }
    
    func testUsingNameOnly() {
        let expect = expectation(description: "")
        Balam("test").describe().sink { _ in
            XCTAssertEqual(.main, Thread.current)
            XCTAssertTrue(FileManager.default.fileExists(atPath: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("test.balam").path))
            expect.fulfill()
        }.store(in: &subs)
        waitForExpectations(timeout: 1)
    }
    
    func testLoadNodes() {
        let expect = expectation(description: "")
        let balam = Balam(url)
        balam.add(User())
        balam.nodes(User.self).sink { _ in
            Balam(self.url).describe().sink {
                XCTAssertEqual(1, $0.count)
                XCTAssertEqual(2, $0.first?.properties.count)
                XCTAssertEqual("User", $0.first?.name)
                expect.fulfill()
            }.store(in: &self.subs)
        }.store(in: &subs)
        waitForExpectations(timeout: 1)
    }
    
    func testDifferentClassesSameName() {
        let balam = Balam(url)
        addClassv1(balam)
        addClassv2(balam)
        XCTAssertEqual(2, balam.items.count)
        balam.items.forEach {
            XCTAssertEqual("Model", $0.name)
            XCTAssertEqual(1, $0.items.count)
        }
    }
    
    func testOptionalValues() {
        let expect = expectation(description: "")
        var user: UserId?
        user = .init()
        let balam = Balam(url)
        balam.add(user)
        balam.nodes(UserId.self).sink {
            XCTAssertTrue($0.isEmpty)
            expect.fulfill()
        }.store(in: &subs)
        waitForExpectations(timeout: 1)
    }
    
    func testOptionalUnwrapped() {
        let expect = expectation(description: "")
        var user: UserId?
        user = .init()
        let balam = Balam(url)
        balam.add(user!)
        balam.nodes(UserId.self).sink {
            XCTAssertEqual(1, $0.count)
            expect.fulfill()
        }.store(in: &subs)
        waitForExpectations(timeout: 1)
    }
    
    private func addClassv1(_ balam: Balam) {
        struct Model: Codable {
            let phone: Float
            let number: Int
        }
        let expect = expectation(description: "")
        balam.nodes(Model.self).sink { _ in
            balam.add(Model(phone: 12.3, number: 4543))
            balam.nodes(Model.self).sink {
                XCTAssertEqual(1, $0.count)
                expect.fulfill()
            }.store(in: &self.subs)
        }.store(in: &subs)
        waitForExpectations(timeout: 1)
    }
    
    private func addClassv2(_ balam: Balam) {
        struct Model: Codable {
            let a: String
            let b: String
            let c: String
        }
        let expect = expectation(description: "")
        balam.nodes(Model.self).sink { _ in
            balam.add(Model(a: "as", b: "bs", c: "cs"))
            balam.nodes(Model.self).sink {
                XCTAssertEqual(1, $0.count)
                expect.fulfill()
            }.store(in: &self.subs)
        }.store(in: &subs)
        waitForExpectations(timeout: 1)
    }
}

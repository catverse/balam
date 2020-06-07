import XCTest
import Combine
@testable import Balam

final class EnumTests: XCTestCase {
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
        balam.add(Mode.cool)
        balam.nodes(Mode.self).sink {
            XCTAssertEqual(.cool, $0.first)
            expect.fulfill()
        }.store(in: &subs)
        waitForExpectations(timeout: 1)
    }
    
    func testAddDifferent() {
        let expect = expectation(description: "")
        balam.add(Mode.uncool)
        balam.nodes(Mode.self).sink {
            XCTAssertEqual(.uncool, $0.first)
            expect.fulfill()
        }.store(in: &subs)
        waitForExpectations(timeout: 1)
    }
    
    func testAddTwo() {
        let expect = expectation(description: "")
        balam.add(Mode.uncool)
        balam.add(Mode.meh)
        balam.nodes(Mode.self).sink {
            XCTAssertTrue($0.contains(.uncool))
            XCTAssertTrue($0.contains(.meh))
            XCTAssertFalse($0.contains(.cool))
            expect.fulfill()
        }.store(in: &subs)
        waitForExpectations(timeout: 1)
    }
    
    func testRemove() {
        let expect = expectation(description: "")
        balam.add(Mode.uncool)
        balam.add(Mode.meh)
        balam.remove(Mode.meh)
        balam.nodes(Mode.self).sink {
            XCTAssertTrue($0.contains(.uncool))
            XCTAssertFalse($0.contains(.meh))
            XCTAssertFalse($0.contains(.cool))
            expect.fulfill()
        }.store(in: &subs)
        waitForExpectations(timeout: 1)
    }
    
    func testReplace() {
        let expect = expectation(description: "")
        balam.add(Mode.uncool)
        balam.replace(Mode.self, with: .cool)
        balam.nodes(Mode.self).sink {
            XCTAssertFalse($0.contains(.uncool))
            XCTAssertFalse($0.contains(.meh))
            XCTAssertTrue($0.contains(.cool))
            XCTAssertEqual(1, $0.count)
            expect.fulfill()
        }.store(in: &subs)
        waitForExpectations(timeout: 1)
    }
}

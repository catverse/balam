import XCTest
import Combine
@testable import Balam

@available(OSX 10.15, *) final class UpdateTests: XCTestCase {
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
    
    func testNonExisiting() {
        let expect = expectation(description: "")
        Balam.graph(url).sink {
            $0.update(UserEqual())
            $0.nodes(UserEqual.self).sink {
                XCTAssertTrue($0.isEmpty)
                expect.fulfill()
            }.store(in: &self.subs)
        }.store(in: &subs)
        waitForExpectations(timeout: 1)
    }
    
    func testEquatable() {
        let expect = expectation(description: "")
        var user = UserEqual()
        Balam.graph(url).sink {
            $0.add(user)
            user.name = "sue"
            try! FileManager.default.removeItem(at: self.url)
            $0.update(user)
            $0.nodes(UserEqual.self).sink {
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
        Balam.graph(url).sink {
            $0.add(user)
            user.name = "sue"
            try! FileManager.default.removeItem(at: self.url)
            $0.update(user)
            $0.nodes(UserId.self).sink {
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
        Balam.graph(url).sink { graph in
            graph.add(user)
            user.name = "some"
            user.last = "sue"
            graph.update(user)
            graph.nodes(UserEqualId.self).sink {
                XCTAssertEqual("", $0.first?.last)
                user.id = 2
                user.name = ""
                graph.update(user)
                graph.nodes(UserEqualId.self).sink {
                    XCTAssertEqual("", $0.first?.last)
                    user.id = 1
                    try! FileManager.default.removeItem(at: self.url)
                    graph.update(user)
                    graph.nodes(UserEqualId.self).sink {
                        XCTAssertEqual(1, $0.count)
                        XCTAssertEqual("sue", $0.first?.last)
                        XCTAssertTrue(FileManager.default.fileExists(atPath: self.url.path))
                        expect.fulfill()
                    }.store(in: &self.subs)
                }.store(in: &self.subs)
            }.store(in: &self.subs)
        }.store(in: &subs)
        waitForExpectations(timeout: 1)
    }
}

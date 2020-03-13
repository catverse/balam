import XCTest
import Combine
@testable import Balam

@available(OSX 10.15, *) final class BalamTests: XCTestCase {
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
    
    func testCreate() {
        let expect = expectation(description: "")
        Balam.graph(url).sink { _ in
            XCTAssertTrue(FileManager.default.fileExists(atPath: self.url.path))
            expect.fulfill()
        }.store(in: &subs)
        waitForExpectations(timeout: 1)
    }
    
    func testLoad() {
        struct User: Codable {
            var name = ""
        }
        let expect = expectation(description: "")
        Balam.graph(url).sink {
            var user = User()
            user.name = "lorem"
            $0.add(user)
            Balam.graph(self.url).sink {
                XCTAssertNotNil($0._nodes(User.self)?.first { $0.name == "lorem" })
                expect.fulfill()
            }.store(in: &self.subs)
        }.store(in: &subs)
        waitForExpectations(timeout: 1)
    }
    
    func testUsingNameOnly() {
        let expect = expectation(description: "")
        Balam.graph("test").sink { _ in
            XCTAssertTrue(FileManager.default.fileExists(atPath: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("test.balam").path))
            expect.fulfill()
        }.store(in: &subs)
        waitForExpectations(timeout: 1)
    }
    
    func testLoadNodes() {
        struct User: Codable {
            var name = ""
        }
        let expect = expectation(description: "")
        Balam.graph(url).sink {
            var user = User()
            user.name = "lorem"
            $0.add(user)
            Balam.nodes(self.url).sink {
                XCTAssertEqual(1, $0.count)
                XCTAssertEqual(1, $0.first?.properties.count)
                XCTAssertEqual("User", $0.first?.name)
                expect.fulfill()
            }.store(in: &self.subs)
        }.store(in: &subs)
        waitForExpectations(timeout: 1)
    }
}

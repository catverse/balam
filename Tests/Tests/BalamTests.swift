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
            $0._add(user)
            Balam.graph(self.url).sink {
                XCTAssertNotNil($0._nodes(User.self)?.first { $0.name == "lorem" })
                expect.fulfill()
            }.store(in: &self.subs)
        }.store(in: &subs)
        waitForExpectations(timeout: 1)
    }
}

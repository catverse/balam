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
        Balam.graph(url).sink(receiveCompletion: {
            XCTAssertEqual(.finished, $0)
            XCTAssertTrue(FileManager.default.fileExists(atPath: self.url.path))
            expect.fulfill()
        }) { _ in }.store(in: &subs)
        waitForExpectations(timeout: 1)
    }
}

import XCTest
import Foundation
import Combine
@testable import Balam

@available(OSX 10.15, *) final class GraphTests: XCTestCase {
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
    
    func testSave() {
        let expect = expectation(description: "")
        let graph = Graph(url)
        graph.saved.sink {
            XCTAssertTrue(FileManager.default.fileExists(atPath: self.url.path))
            expect.fulfill()
        }.store(in: &subs)
        graph.save()
        waitForExpectations(timeout: 1)
    }
}

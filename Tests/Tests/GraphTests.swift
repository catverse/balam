import XCTest
import Combine
@testable import Balam

@available(OSX 10.15, *) final class GraphTests: XCTestCase {
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
    
    func testDifferentClassesSameName() {
        let graph = Balam(url, queue: .main)
        addClassv1(graph)
        addClassv2(graph)
        XCTAssertEqual(2, graph.items.count)
        graph.items.forEach {
            XCTAssertEqual("Model", $0.name)
            XCTAssertEqual(1, $0.items.count)
        }
    }
    
    private func addClassv1(_ graph: Balam) {
        struct Model: Codable {
            let phone: Float
            let number: Int
        }
        let expect = expectation(description: "")
        graph.nodes(Model.self).sink { _ in
            graph.add(Model(phone: 12.3, number: 4543))
            graph.nodes(Model.self).sink {
                XCTAssertEqual(1, $0.count)
                expect.fulfill()
            }.store(in: &self.subs)
        }.store(in: &subs)
        waitForExpectations(timeout: 1)
    }
    
    private func addClassv2(_ graph: Balam) {
        struct Model: Codable {
            let a: String
            let b: String
            let c: String
        }
        let expect = expectation(description: "")
        graph.nodes(Model.self).sink { _ in
            graph.add(Model(a: "as", b: "bs", c: "cs"))
            graph.nodes(Model.self).sink {
                XCTAssertEqual(1, $0.count)
                expect.fulfill()
            }.store(in: &self.subs)
        }.store(in: &subs)
        waitForExpectations(timeout: 1)
    }
}

import XCTest
@testable import Balam

@available(OSX 10.15, *) final class GraphTests: XCTestCase {
    private var url: URL!
    
    override func setUp() {
        url = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("test")
        try? FileManager.default.removeItem(at: url)
    }
    
    override func tearDown() {
        try? FileManager.default.removeItem(at: url)
    }
    
    func testDifferentClassesSameName() {
        let graph = Graph(url, queue: .main)
        addClassv1(graph)
        addClassv2(graph)
        XCTAssertEqual(2, graph.items.count)
        graph.items.forEach {
            XCTAssertEqual("Model", $0.name)
            XCTAssertEqual(1, $0.items.count)
        }
    }
    
    private func addClassv1(_ graph: Graph) {
        struct Model: Codable {
            let phone: Float
            let number: Int
        }
        _ = graph._nodes(Model.self)
        graph._add(Model(phone: 12.3, number: 4543))
        let models = graph._nodes(Model.self)
        XCTAssertEqual(1, models?.count)
    }
    
    private func addClassv2(_ graph: Graph) {
        struct Model: Codable {
            let a: String
            let b: String
            let c: String
        }
        _ = graph._nodes(Model.self)
        graph._add(Model(a: "as", b: "bs", c: "cs"))
        let models = graph._nodes(Model.self)
        XCTAssertEqual(1, models?.count)
    }
}

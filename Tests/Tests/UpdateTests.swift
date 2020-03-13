import XCTest
@testable import Balam

@available(OSX 10.15, *) final class UpdateTests: XCTestCase {
    private var url: URL!
    
    override func setUp() {
        url = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("test")
        try? FileManager.default.removeItem(at: url)
    }
    /*
    override func tearDown() {
        try? FileManager.default.removeItem(at: url)
    }
    
    func testUpdateNode() {
        let graph = Graph(url, queue: .main)
        graph._add(UserWithId())
        var user = graph._nodes(UserWithId.self)!.first!
        user.name = "hello world"
        user.age = 456
        try! FileManager.default.removeItem(at: url)
        graph._update(user)
        let users = graph._nodes(UserWithId.self)
        XCTAssertEqual(1, users?.count)
        XCTAssertEqual("hello world", users?.first?.name)
        XCTAssertEqual(456, users?.first?.age)
        XCTAssertTrue(FileManager.default.fileExists(atPath: url.path))
    }*/
}

private struct UserWithId: Codable, Identifiable {
    var id = 0
    var name = "Some name"
    var age = 123
}

import Foundation

struct Mutable<T> where T : Codable {
    private var node: Node
    private var items = [T]()
    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()
    
    init(_ node: Node, type: T.Type) {
        self.node = node
        items = node.items.map { try! decoder.decode(T.self, from: $0) }
    }
    
    mutating func add(_ item: T, duplicated: (T) -> Bool) {
        if !items.contains(where: duplicated) {
            items.append(item)
        }
    }
    
    mutating func storable() -> Node {
        node.items = .init(items.map { try! encoder.encode($0) })
        return node
    }
}

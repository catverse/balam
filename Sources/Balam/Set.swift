import Foundation

extension Set where Set.Element == Node {
    mutating func mutate<T>(items: [T], mutating: (inout [T]) -> Void) where T : Codable {
        items.first.map { mutate(item: $0, mutating: mutating) }
    }
    
    mutating func mutate<T>(item: T, mutating: (inout [T]) -> Void) where T : Codable {
        {
            var node = remove($0) ?? $0
            var items = node.items.map { try! JSONDecoder().decode(T.self, from: $0) }
            mutating(&items)
            node.items = .init(items.map { try! JSONEncoder().encode($0) })
            insert(node)
        } (Node(item))
    }
}

import Foundation

extension Set where Set.Element == Node {
    mutating func add<T>(_ item: T) where T : Codable {
        node(item) {
            try! $0.items.insert(JSONEncoder().encode(item))
        }
    }
    
    mutating func add<T>(_ item: T, excluding: (T) -> Bool) where T : Codable {
        mutate(item) {
            if !$0.contains(where: excluding) {
                $0.append(item)
            }
        }
    }
    
    mutating func add<T>(_ items: [T]) where T : Codable {
        items.first.map {
            node($0) { mutating in
                items.forEach {
                    try! mutating.items.insert(JSONEncoder().encode($0))
                }
            }
        }
    }
    
    mutating func add<T>(_ items: [T], excluding: (T, T) -> Bool) where T : Codable {
        items.first.map {
            mutate($0) { mutating in
                items.forEach { item in
                    if !mutating.contains(where: { excluding(item, $0) }) {
                        mutating.append(item)
                    }
                }
            }
        }
    }
    
    mutating func update<T>(_ item: T, when: (T) -> Bool) where T : Codable {
        mutate(item) { mutating in
            mutating.firstIndex(where: when).map {
                mutating.remove(at: $0)
                mutating.append(item)
            }
        }
    }
    
    private mutating func mutate<T>(_ item: T, mutating: (inout [T]) -> Void) where T : Codable {
        node(item) {
            var items = $0.items.map { try! JSONDecoder().decode(T.self, from: $0) }
            mutating(&items)
            $0.items = .init(items.map { try! JSONEncoder().encode($0) })
        }
    }
    
    private mutating func node<T>(_ item: T, mutating: (inout Node) -> Void) where T : Codable {
        {
            var node = remove($0) ?? $0
            mutating(&node)
            insert(node)
        } (Node(item))
    }
}

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
    
    mutating func update<T>(_ type: T.Type, with: (inout T) -> Void) where T : Codable {
        node(type) {
            $0?.mutate(mutating: with)
        }
    }
    
    mutating func delete<T>(_ item: T) where T : Codable {
        node(item) {
            try! $0.items.remove(JSONEncoder().encode(item))
        }
    }
    
    mutating func delete<T>(_ item: T, when: (T) -> Bool) where T : Codable {
        mutate(item) {
            $0.removeAll(where: when)
        }
    }
    
    mutating func delete<T>(_ when: (T) -> Bool) where T : Codable {
        node(T.self) {
            $0?.mutate {
                $0.removeAll(where: when)
            }
        }
    }
    
    private mutating func mutate<T>(_ item: T, mutating: (inout [T]) -> Void) where T : Codable {
        node(item) {
            $0.mutate(mutating: mutating)
        }
    }
    
    private mutating func node<T>(_ item: T, mutating: (inout Node) -> Void) where T : Codable {
        {
            var node = remove($0) ?? $0
            mutating(&node)
            insert(node)
        } (Node(item))
    }
    
    private mutating func node<T>(_ type: T.Type, mutating: (inout Node?) -> Void) where T : Codable {
        var node = firstIndex { $0 == type }.map { remove(at: $0) }
        mutating(&node)
        _ = node.map { insert($0) }
    }
}

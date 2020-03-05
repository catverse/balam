import Foundation
import Combine

@available(OSX 10.15, *) public final class Graph {
    private(set) var nodes = Set<Node>()
    private let url: URL
    private let queue: DispatchQueue
    
    init(_ url: URL, queue: DispatchQueue) {
        self.url = url
        self.queue = queue
        guard
            FileManager.default.fileExists(atPath: url.path),
            let nodes = try? JSONDecoder().decode(Set<Node>.self, from: (.init(contentsOf: url) as NSData).decompressed(using: .lzfse) as Data)
        else {
            save()
            return
        }
        self.nodes = nodes
    }
    
    public func add<T>(_ node: T) where T : Codable {
        queue.async { self._add(node) }
    }
    
    public func add<T>(_ node: T) where T : Codable, T : Identifiable {
        queue.async { self._add(node) }
    }
    
    public func add<T>(_ nodes: [T]) where T : Codable {
        queue.async { self._add(nodes) }
    }
    
    public func add<T>(_ nodes: [T]) where T : Codable, T : Identifiable {
        queue.async { self._add(nodes) }
    }
    
    public func update<T>(_ node: T) where T : Codable, T : Identifiable {
        queue.async { self._update(node) }
    }
    
    public func remove<T>(_ node: T) where T : Codable, T : Identifiable {
        queue.async { self._remove(node) }
    }
    
    public func nodes<T>(_ type: T.Type) -> Future<[T], Never> where T : Codable {
        .init { promise in
            self.queue.async {
                promise(.success(self._nodes(type) ?? []))
            }
        }
    }
    
    func _add<T>(_ node: T) where T : Codable, T : Identifiable {
        _update(node)
        save()
    }
    
    func _add<T>(_ node: T) where T : Codable {
        var container = find(.init(node))
        insert(node, container: &container)
        save()
    }
    
    func _add<T>(_ nodes: [T]) where T : Codable {
        nodes.first.map {
            var container = find(.init($0))
            nodes.forEach {
                try! container.items.insert(JSONEncoder().encode($0))
            }
            self.nodes.insert(container)
            save()
        }
    }
    
    func _add<T>(_ nodes: [T]) where T : Codable, T : Identifiable {
        nodes.first.map {
            var container = find(.init($0))
            nodes.forEach { node in
                container.items.firstIndex { try! JSONDecoder().decode(T.self, from: $0).id == node.id }.map { _ = container.items.remove(at: $0) }
                try! container.items.insert(JSONEncoder().encode(node))
            }
            self.nodes.insert(container)
            save()
        }
    }
    
    func _update<T>(_ node: T) where T : Codable, T : Identifiable {
        var container = find(.init(node))
        remove(node, container: &container)
        insert(node, container: &container)
        save()
    }
    
    func _remove<T>(_ node: T) where T : Codable, T : Identifiable {
        var container = find(.init(node))
        remove(node, container: &container)
        nodes.insert(container)
        save()
    }
    
    func _remove<T>(_ type: T.Type, when: (T) -> Bool) where T : Codable {
        guard var container = find(type) else { return }
        nodes.remove(container)
        container.items = container.items.reduce(into: .init()) {
            guard when(try! JSONDecoder().decode(T.self, from: $1)) else { return }
            $0.insert($1)
        }
        nodes.insert(container)
        save()
    }
    
    func _nodes<T>(_ type: T.Type) -> [T]? where T : Codable {
        find(type)?.items.map { try! JSONDecoder().decode(type, from: $0) }
    }
    
    private func insert<T>(_ node: T, container: inout Node) where T : Codable {
        try! container.items.insert(JSONEncoder().encode(node))
        nodes.insert(container)
    }
    
    private func remove<T>(_ node: T, container: inout Node) where T : Codable, T : Identifiable {
        container.items.firstIndex { try! JSONDecoder().decode(T.self, from: $0).id == node.id }.map { _ = container.items.remove(at: $0) }
    }
    
    private func find(_ node: Node) -> Node {
        nodes.remove(node) ?? node
    }
    
    private func find<T>(_ type: T.Type) -> Node? where T : Codable {
        nodes.filter { $0.name == .init(describing: type) }.first {
            guard
                let item = $0.items.first,
                let decoded = try? JSONDecoder().decode(type, from: item)
            else { return false }
            return $0 == Node(decoded)
        }
    }
    
    private func save() {
        try! (JSONEncoder().encode(nodes) as NSData).compressed(using: .lzfse).write(to: url, options: .atomic)
    }
}

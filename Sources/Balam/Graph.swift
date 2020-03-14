import Foundation
import Combine

@available(OSX 10.15, *) public final class Graph {
    private(set) var items = Set<Node>()
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
        self.items = nodes
    }
    
    public func add<T>(_ node: T) where T : Codable {
        queue.async {
            self.items.add(node)
            self.save()
        }
    }
    
    public func add<T>(_ node: T) where T : Codable & Equatable {
        queue.async {
            self.items.add(node) { node == $0 }
            self.save()
        }
    }
    
    public func add<T>(_ node: T) where T : Codable & Identifiable {
        queue.async {
            self.items.add(node) { node.id == $0.id }
            self.save()
        }
    }
    
    public func add<T>(_ node: T) where T : Codable & Equatable & Identifiable {
        queue.async {
            self.items.add(node) { node.id == $0.id && node == $0 }
            self.save()
        }
    }
    
    public func add<T>(_ nodes: [T]) where T : Codable {
        queue.async {
            self.items.add(nodes)
            self.save()
        }
    }
    
    public func add<T>(_ nodes: [T]) where T : Codable & Equatable {
        queue.async {
            self.items.add(nodes) { $0 == $1 }
            self.save()
        }
    }

    public func add<T>(_ nodes: [T]) where T : Codable & Identifiable {
        queue.async {
            self.items.add(nodes) { $0.id == $1.id }
            self.save()
        }
    }
    
    public func add<T>(_ nodes: [T]) where T : Codable & Equatable & Identifiable {
        queue.async {
            self.items.add(nodes) { $0.id == $1.id && $0 == $1 }
            self.save()
        }
    }
    
    public func update<T>(_ node: T) where T : Codable & Equatable {
        queue.async {
            self.items.update(node) { node == $0 }
            self.save()
        }
    }
    
    public func update<T>(_ node: T) where T : Codable & Identifiable {
        queue.async {
            self.items.update(node) { node.id == $0.id }
            self.save()
        }
    }
    
    public func update<T>(_ node: T) where T : Codable & Equatable & Identifiable {
        queue.async {
            self.items.update(node) { node.id == $0.id && node == $0 }
            self.save()
        }
    }
    
    public func remove<T>(_ node: T) where T : Codable {
        queue.async {
            self.items.remove(node)
            self.save()
        }
    }
    
    
    
    
    
    
    
    
    
    public func remove<T>(_ node: T) where T : Codable, T : Identifiable {

    }
    
    public func remove<T>(_ type: T.Type, when: @escaping (T) -> Bool) where T : Codable {

    }
    
    public func nodes<T>(_ type: T.Type) -> Future<[T], Never> where T : Codable {
        .init { promise in
            self.queue.async {
                promise(.success(self._nodes(type) ?? []))
            }
        }
    }
    
    func _update<T>(_ node: T) where T : Codable, T : Identifiable {
//        var container = find(.init(node))
//        remove(node, container: &container)
//        insert(node, container: &container)
//        save()
    }
    
    func _remove<T>(_ node: T) where T : Codable, T : Identifiable {
//        var container = find(.init(node))
//        remove(node, container: &container)
//        nodes.insert(container)
//        save()
    }
    
    func _remove<T>(_ type: T.Type, when: @escaping (T) -> Bool) where T : Codable {
        guard var container = find(type) else { return }
        items.remove(container)
        container.items = container.items.reduce(into: .init()) {
            guard !when(try! JSONDecoder().decode(T.self, from: $1)) else { return }
            $0.insert($1)
        }
        items.insert(container)
        save()
    }
    
    func _nodes<T>(_ type: T.Type) -> [T]? where T : Codable {
        find(type)?.items.map { try! JSONDecoder().decode(type, from: $0) }
    }
    
    private func insert<T>(_ node: T, container: inout Node) where T : Codable {
        try! container.items.insert(JSONEncoder().encode(node))
        items.insert(container)
    }
    
    private func remove<T>(_ node: T, container: inout Node) where T : Codable, T : Identifiable {
        container.items.firstIndex { try! JSONDecoder().decode(T.self, from: $0).id == node.id }.map { _ = container.items.remove(at: $0) }
    }
    
    private func find<T>(_ type: T.Type) -> Node? where T : Codable {
        items.filter { $0.name == .init(describing: type) }.first {
            guard
                let item = $0.items.first,
                let decoded = try? JSONDecoder().decode(type, from: item)
            else { return false }
            return $0 == Node(decoded)
        }
    }
    
    private func save() {
        try! (JSONEncoder().encode(items) as NSData).compressed(using: .lzfse).write(to: url, options: .atomic)
    }
}

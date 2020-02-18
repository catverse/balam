import Foundation
import Combine

@available(OSX 10.15, *) public final class Graph {
    private(set) var nodes = Set<Node>()
    private let url: URL
    private let queue = DispatchQueue(label: "", qos: .utility)
    
    init(_ url: URL) {
        self.url = url
        save()
    }
    
    public func add<T>(_ node: T) where T : Encodable {
        queue.async { [weak self] in self?._add(node) }
    }
    
    public func nodes<T>(_ type: T.Type) -> Future<[T], Never> where T : Decodable {
        .init { [weak self] promise in
            self?.queue.async {
                promise(.success(self?._nodes(type) ?? []))
            }
        }
    }
    
    public func update<T>(_ node: T) where T : Codable {
        queue.async { [weak self] in
            self?.update(node)
        }
    }
    
    func _add<T>(_ node: T) where T : Encodable {
        var container = nodeFor(.init(node))
        try! container.items.insert(JSONEncoder().encode(node))
        nodes.insert(container)
    }
    
    func _update<T>(_ node: T) where T : Codable, T : Identifiable {
        var container = nodeFor(.init(node))
        container.items.firstIndex { try! JSONDecoder().decode(T.self, from: $0).id == node.id }.map { _ = container.items.remove(at: $0) }
        try! container.items.insert(JSONEncoder().encode(node))
        nodes.insert(container)
    }
    
    func _nodes<T>(_ type: T.Type) -> [T]? where T : Decodable {
        nodes.filter { $0.name == .init(describing: type) }.first {
            guard
                let item = $0.items.first,
                let decoded = try? JSONDecoder().decode(type, from: item)
            else { return false }
            return $0 == Node(decoded)
        }?.items.map { try! JSONDecoder().decode(type, from: $0) }
    }
    
    func save() {
        try! Data().write(to: url, options: .atomic)
    }
    
    private func nodeFor(_ node: Node) -> Node {
        nodes.remove(node) ?? node
    }
}

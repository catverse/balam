import Foundation
import Combine

@available(OSX 10.15, *) public final class Graph {
    private(set) var nodes = Set<Node>()
    private let url: URL
    private let queue = DispatchQueue(label: "", qos: .background, target: .global(qos: .background))
    
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
    
    func _add<T>(_ node: T) where T : Encodable {
        var container = nodes.first { $0.name == .init(describing: type(of: node)) } ?? Node(node)
        nodes.remove(container)
        try! container.items.append(JSONEncoder().encode(node))
        nodes.insert(container)
    }
    
    func _update<T>(_ node: T) where T : Codable, T : Identifiable {
        var container = nodes.first { $0.name == .init(describing: type(of: node)) } ?? Node(node)
        nodes.remove(container)
        container.items.removeAll { try! JSONDecoder().decode(T.self, from: $0).id == node.id }
        try! container.items.append(JSONEncoder().encode(node))
        nodes.insert(container)
    }
    
    func _nodes<T>(_ type: T.Type) -> [T]? where T : Decodable {
        nodes.first { $0.name == .init(describing: type) }?.items.compactMap { try? JSONDecoder().decode(type, from: $0) }
    }
    
    func save() {
        try! Data().write(to: url, options: .atomic)
    }
}
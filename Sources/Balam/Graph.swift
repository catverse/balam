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
        queue.async { [weak self] in self?._add(node) }
    }
    
    public func nodes<T>(_ type: T.Type) -> Future<[T], Never> where T : Codable {
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
    
    func _add<T>(_ node: T) where T : Codable {
        var container = find(.init(node))
        try! container.items.insert(JSONEncoder().encode(node))
        nodes.insert(container)
        save()
    }
    
    func _update<T>(_ node: T) where T : Codable, T : Identifiable {
        var container = find(.init(node))
        container.items.firstIndex { try! JSONDecoder().decode(T.self, from: $0).id == node.id }.map { _ = container.items.remove(at: $0) }
        try! container.items.insert(JSONEncoder().encode(node))
        nodes.insert(container)
        save()
    }
    
    func _nodes<T>(_ type: T.Type) -> [T]? where T : Codable {
        nodes.filter { $0.name == .init(describing: type) }.first {
            guard
                let item = $0.items.first,
                let decoded = try? JSONDecoder().decode(type, from: item)
            else { return false }
            return $0 == Node(decoded)
        }?.items.map { try! JSONDecoder().decode(type, from: $0) }
    }
    
    private func save() {
        try! (JSONEncoder().encode(nodes) as NSData).compressed(using: .lzfse).write(to: url, options: .atomic)
    }
    
    private func find(_ node: Node) -> Node {
        nodes.remove(node) ?? node
    }
}

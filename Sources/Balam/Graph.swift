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
            self.items.delete(node)
            self.save()
        }
    }
    
    public func remove<T>(_ node: T) where T : Codable & Equatable {
        queue.async {
            self.items.delete(node) { node == $0 }
            self.save()
        }
    }
    
    public func remove<T>(_ node: T) where T : Codable & Identifiable {
        queue.async {
            self.items.delete(node) { node.id == $0.id }
            self.save()
        }
    }
    
    public func remove<T>(_ node: T) where T : Codable & Equatable & Identifiable {
        queue.async {
            self.items.delete(node) { node.id == $0.id && node == $0 }
            self.save()
        }
    }
    
    public func remove<T>(_ type: T.Type, when: @escaping (T) -> Bool) where T : Codable {
        queue.async {
            self.items.delete(type, when: when)
            self.save()
        }
    }
    
    public func nodes<T>(_ type: T.Type) -> Future<[T], Never> where T : Codable {
        .init { promise in
            self.queue.async {
                promise(.success(self.items.first { $0 == type }?.decoding() ?? []))
            }
        }
    }
    
    private func save() {
        try! (JSONEncoder().encode(items) as NSData).compressed(using: .lzfse).write(to: url, options: .atomic)
    }
}

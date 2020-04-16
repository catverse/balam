import Foundation
import Combine

public final class Balam {
    private(set) var items = Set<Node>()
    private let url: URL
    private let queue = DispatchQueue(label: "", qos: .utility)
    
    public convenience init(_ name: String) {
        self.init(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(name + ".balam"))
    }
    
    public init(_ url: URL) {
        self.url = url
        queue.async {
            guard
                FileManager.default.fileExists(atPath: url.path),
                let nodes = try? JSONDecoder().decode(Set<Node>.self, from: (.init(contentsOf: url) as NSData).decompressed(using: .lzfse) as Data)
            else {
                self.save()
                return
            }
            self.items = nodes
        }
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
    
    public func update<T>(_ type: T.Type, with: @escaping (inout T) -> Void) where T : Codable {
        queue.async {
            self.items.update(type, with: with)
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
            self.items.delete(when)
            self.save()
        }
    }
    
    public func nodes<T>(_ type: T.Type) -> Future<[T], Never> where T : Codable {
        .init { promise in
            self.queue.async {
                let result = Result<[T], Never>.success(self.items.first { $0 == type }?.decoding() ?? [])
                DispatchQueue.main.async {
                    promise(result)
                }
            }
        }
    }
    
    public func describe() -> Future<Set<Node>, Never> {
        .init { promise in
            self.queue.async {
                let result = Result<Set<Node>, Never>.success(self.items)
                DispatchQueue.main.async {
                    promise(result)
                }
            }
        }
    }
    
    private func save() {
        try! (JSONEncoder().encode(items) as NSData).compressed(using: .lzfse).write(to: url, options: .atomic)
    }
}

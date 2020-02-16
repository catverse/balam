import Foundation
import Combine

@available(OSX 10.15, *) public final class Graph {
    public let saved = PassthroughSubject<Void, Never>()
    private(set) var nodes = Set<Node>()
    private let url: URL
    private let queue = DispatchQueue(label: "", qos: .background, target: .global(qos: .background))
    
    init(_ url: URL) {
        self.url = url
    }
    
    public func add<T>(_ node: T) where T : Encodable {
        queue.async { [weak self] in
            guard let self = self else { return }
            var container = self.nodes.first { $0.name == .init(describing: type(of: node)) } ?? Node(node)
            self.nodes.remove(container)
            try! container.items.append(JSONEncoder().encode(node))
            self.nodes.insert(container)
            self.save()
        }
    }
    
    func save() {
        queue.async { [weak self] in
            guard let self = self else { return }
            try! Data().write(to: self.url, options: .atomic)
            self.saved.send()
        }
    }
}

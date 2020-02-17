import Foundation
import Combine

@available(OSX 10.15, *) public final class Graph {
    private(set) var nodes = Set<Node>()
    private let url: URL
    private let queue = DispatchQueue(label: "", qos: .background, target: .global(qos: .background))
    
    init(_ url: URL) {
        self.url = url
    }
    
    public func add<T>(_ node: T) where T : Encodable {
        queue.async { [weak self] in self?._add(node) }
    }
    
    public func get<T>(_ nodes: T.Type) -> GetPublisher<T> where T : Decodable {
        let publisher = GetPublisher<T>()
        return publisher
    }
    
    func _add<T>(_ node: T) where T : Encodable {
        var container = nodes.first { $0.name == .init(describing: type(of: node)) } ?? Node(node)
        nodes.remove(container)
        try! container.items.append(JSONEncoder().encode(node))
        nodes.insert(container)
    }
    
    func save() {
        try! Data().write(to: url, options: .atomic)
    }
    
    public final class GetPublisher<T>: Publisher {
        public typealias Output = [T]
        public typealias Failure = Never
        
        @available(OSX 10.15, *) public func receive<S>(subscriber: S) where S : Subscriber, [T] == S.Input {
            subscriber.receive(subscription: GetSubscription())
        }
    }
    
    final class GetSubscription: Subscription {
        func request(_ demand: Subscribers.Demand) {
            
        }
        
        func cancel() {
            
        }
        
        
    }
}

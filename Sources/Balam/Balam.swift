import Foundation
import Combine

@available(OSX 10.15, *) public final class Balam {
    public class func graph(_ url: URL) -> GraphPublisher {
        GraphPublisher(url)
    }
    
    public final class GraphPublisher: Publisher {
        public typealias Output = Graph
        public typealias Failure = Never
        private var sub: AnyCancellable?
        private let graph: Graph
        
        fileprivate init(_ url: URL) {
            graph = .init(url)
        }
        
        @available(OSX 10.15, *) public func receive<S>(subscriber: S) where S : Subscriber, Graph == S.Input {
            sub = graph.saved.sink {
                _ = subscriber.receive(self.graph)
            }
            graph.save()
        }
    }
}

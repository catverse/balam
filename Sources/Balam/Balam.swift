import Foundation
import Combine

public final class Balam {
    public class func graph(_ url: URL) -> GraphPublisher {
        GraphPublisher(url)
    }
    
    public struct GraphPublisher: Publisher {
        public typealias Output = Graph
        public typealias Failure = Never
        private let url: URL
        
        fileprivate init(_ url: URL) {
            self.url = url
        }
        
        @available(OSX 10.15, *) public func receive<S>(subscriber: S) where S : Subscriber, Never == S.Failure, Graph == S.Input {
            DispatchQueue.global(qos: .background).async {
                try! Data().write(to: self.url, options: .atomic)
                subscriber.receive(completion: .finished)
            }
        }
    }
}

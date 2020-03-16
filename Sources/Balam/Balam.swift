import Foundation
import Combine

@available(OSX 10.15, *, iOS 13.0, *, watchOS 6.0, *) public final class Balam {
    public class func graph(_ name: String) -> Future<Graph, Never> {
        graph(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(name + ".balam"))
    }
    
    public class func graph(_ url: URL) -> Future<Graph, Never> {
        .init { promise in
            let queue = DispatchQueue(label: "", qos: .utility)
            queue.async {
                promise(.success(.init(url, queue: queue)))
            }
        }
    }
    
    public class func nodes(_ url: URL) -> Future<Set<Node>, Never> {
        .init { promise in
            let queue = DispatchQueue(label: "", qos: .utility)
            queue.async {
                promise(.success(Graph(url, queue: queue).items))
            }
        }
    }
}

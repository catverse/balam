import Foundation
import Combine

@available(OSX 10.15, *) public final class Balam {
    public class func graph(_ url: URL) -> Future<Graph, Never> {
        .init { promise in
            let graph = Graph(url)
            let subs = graph.load().sink {
                promise(.success(graph))
            }
        }
    }
}

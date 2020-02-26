import Foundation
import Combine

@available(OSX 10.15, *) public final class Balam {
    public class func graph(_ url: URL) -> Future<Graph, Never> {
        .init { promise in
            let queue = DispatchQueue(label: "", qos: .utility)
            queue.async {
                promise(.success(.init(url, queue: queue)))
            }
        }
    }
}

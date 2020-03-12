import Foundation

extension Set where Set.Element == Node {
    mutating func mutate<T>(_ node: T) -> Mutable<T> where T : Codable {
        {
            .init(remove($0) ?? $0, type: T.self)
        } (Node(node))
    }
    
    mutating func mutate<T>(_ nodes: [T]) -> Mutable<T>? where T : Codable {
        nodes.first.map {
            {
                .init(remove($0) ?? $0, type: T.self)
            } (Node($0))
        }
    }
}

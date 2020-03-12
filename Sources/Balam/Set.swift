import Foundation

extension Set where Set.Element == Node {
    mutating func mutate<T>(_ items: [T], mutating: (inout Mutable<T>) -> Void) where T : Codable {
        items.first.map { mutate($0, mutating: mutating) }
    }
    
    mutating func mutate<T>(_ item: T, mutating: (inout Mutable<T>) -> Void) where T : Codable {
        {
            var mutable = Mutable(remove($0) ?? $0, type: T.self)
            mutating(&mutable)
            insert(mutable.storable())
        } (Node(item))
    }
}

import Foundation
import Combine

@available(OSX 10.15, *) public final class Graph {
    public let saved: AnyPublisher<Never, Never>
    private let saveSubject = PassthroughSubject<Never, Never>()
    private let url: URL
    
    init(_ url: URL) {
        self.url = url
        saved = saveSubject.eraseToAnyPublisher()
    }
    
    public func save() {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self = self else { return }
            try! Data().write(to: self.url, options: .atomic)
            self.saveSubject.send(completion: .finished)
        }
    }
}

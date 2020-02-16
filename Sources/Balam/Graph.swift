import Foundation
import Combine

@available(OSX 10.15, *) public final class Graph {
    public let saved: AnyPublisher<Void, Never>
    private let saveSubject = PassthroughSubject<Void, Never>()
    private let url: URL
    
    init(_ url: URL) {
        self.url = url
        saved = saveSubject.eraseToAnyPublisher()
    }
    
    public func save() {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self = self else { return }
            try! Data().write(to: self.url, options: .atomic)
            self.saveSubject.send()
        }
    }
}

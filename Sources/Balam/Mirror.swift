import Foundation

extension Mirror {
    func reflect<T>(_ object: T) -> Set<Property> where T : Codable {
        children.reduce(into: .init()) {
            $0.insert(isNil($1.1)
                ? guess($1.0!, object: object)
                : {
                    $1 == .optional ? .Optional($0) : $0
                } (child($1.0!, value: $1.1), Mirror(reflecting: $1.1).displayStyle))
        }
    }
    
    private func guess<T>(_ property: String, object: T) -> Property where T : Codable {
        for value in ["", 0, false] as [Any] {
            var json = try! JSONSerialization.jsonObject(with: JSONEncoder().encode(object)) as! [String : Any]
            json[property] = value
            if let decoded = try? JSONDecoder().decode(T.self, from: JSONSerialization.data(withJSONObject: json)) {
                return .Optional(child(property, value: Mirror(reflecting: decoded).children.first { $0.label == property }!.value))
            }
        }
        return .Optional(.Custom(property))
    }
    
    private func child(_ name: String, value: Any) -> Property {
        switch value {
        case is String: return .String(name)
        case is Int: return .Int(name)
        case is Double: return .Double(name)
        case is Bool: return .Boolean(name)
        case is [String]: return .Array(.String(name))
        default: return .Custom(name)
        }
    }
    
    private func isNil(_ value: Any) -> Bool {
        nil == { cast(value) } () as Any?
    }
    
    private func cast<T>(_ value: Any) -> T {
        value as! T
    }
}

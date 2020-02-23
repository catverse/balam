import Foundation

extension Mirror {
    func reflect<T>(_ object: T) -> Set<Property> where T : Codable {
        children.reduce(into: .init()) {
            $0.insert(isNil($1.1)
                ? .Optional(guess($1.0!, object: object))
                : {
                    $1 == .optional ? .Optional($0) : $0
                } (isEmpty($1.1) ? guess($1.0!, object: object) : wrapped($1.0!, value: $1.1), Mirror(reflecting: $1.1).displayStyle))
        }
    }
    
    private func guess<T>(_ property: String, object: T) -> Property where T : Codable {
        ["", 0, false, [""], [0], [false]].compactMap {
            var json = try! JSONSerialization.jsonObject(with: JSONEncoder().encode(object)) as! [String : Any]
            json[property] = $0
            return (try? JSONDecoder().decode(T.self, from: JSONSerialization.data(withJSONObject: json))).map {
                Mirror(reflecting: $0).children.first { $0.label == property }!.value
            }
        }.first.map { wrapped(property, value: $0) } ?? .Custom(property)
    }
    
    private func wrapped(_ name: String, value: Any) -> Property {
        value is [Any] ? .Array(child(name, value: (value as! [Any]).first!)) : child(name, value: value)
    }
    
    private func child(_ name: String, value: Any) -> Property {
        switch value {
        case is String: return .String(name)
        case is Int: return .Int(name)
        case is Double: return .Double(name)
        case is Bool: return .Boolean(name)
        default: return .Custom(name)
        }
    }
    
    private func isEmpty(_ value: Any) -> Bool {
        value is [Any] ? (value as! [Any]).first.map { isNil($0) } ?? true : false
    }
    
    private func isNil(_ value: Any) -> Bool {
        nil == { cast(value) } () as Any?
    }
    
    private func cast<T>(_ value: Any) -> T {
        value as! T
    }
}

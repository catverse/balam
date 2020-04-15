import Foundation

extension Mirror {
    func reflect<T>(_ object: T) -> Set<Property> where T : Codable {
        children.reduce(into: .init()) {
            let property = $1.0 ?? ""
            let value = $1.1
            $0.insert(isNil(value)
                ? .Optional(guess(property, object: object))
                : {
                    $1 == .optional ? .Optional($0) : $0
                } (isEmpty(value) ? guess(property, object: object) : wrapped(property, value: value), Mirror(reflecting: value).displayStyle))
        }
    }
    
    private func guess<T>(_ property: String, object: T) -> Property where T : Codable {
        ["", 0, false].flatMap {
            [$0, [$0], [[$0]]].compactMap {
                inject($0, property: property, object: object)
            }
        }.first.map { wrapped(property, value: $0) } ?? .Custom(property)
    }
    
    private func wrapped(_ name: String, value: Any) -> Property {
        value is [Any]
            ? .Array((value as! [Any]).first.map { wrapped(name, value: $0) } ?? .Custom(name))
            : value is [AnyHashable : Any]
            ? .Dictionary(name,
                          key: (value as! [AnyHashable : Any]).keys.first.map { wrapped("", value: $0) } ?? .Custom(""),
                          value: (value as! [AnyHashable : Any]).values.first.map { wrapped("", value: $0) } ?? .Custom(""))
                : child(name, value: value)
    }
    
    private func child(_ name: String, value: Any) -> Property {
        switch value {
        case is String: return .String(name)
        case is Int: return .Int(name)
        case is Double: return .Double(name)
        case is Bool: return .Boolean(name)
        case is Float: return .Float(name)
        case is Data: return .Data(name)
        case is Date: return .Date(name)
        case is UInt8: return .UInt8(name)
        case is UInt16: return .UInt16(name)
        case is UInt32: return .UInt32(name)
        case is UInt64: return .UInt64(name)
        case is Int8: return .Int8(name)
        case is Int16: return .Int16(name)
        case is Int32: return .Int32(name)
        case is Int64: return .Int64(name)
        case is URL: return .URL(name)
        case is UUID: return .UUID(name)
        default: return .Custom(name)
        }
    }
    
    private func inject<T>(_ meta: Any, property: String, object: T) -> Any? where T : Codable {
        var json = try! JSONSerialization.jsonObject(with: JSONEncoder().encode(object)) as! [String : Any]
        json[property] = meta
        return (try? JSONDecoder().decode(T.self, from: JSONSerialization.data(withJSONObject: json))).map {
            Mirror(reflecting: $0).children.first { $0.label == property }!.value
        }
    }
    
    private func isEmpty(_ value: Any) -> Bool {
        value is [Any] ? (value as! [Any]).first.map(isNil) ?? true : false
    }
    
    private func isNil(_ value: Any) -> Bool {
        nil == { cast(value) } () as Any?
    }
    
    private func cast<T>(_ value: Any) -> T {
        value as! T
    }
}

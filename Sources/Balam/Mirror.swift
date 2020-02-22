import Foundation

extension Mirror {
    var reflect: Set<Property> {
        children.reduce(into: .init()) {
            $0.insert(property($1))
        }
    }
    
    private func property(_ child: (String?, Any)) -> Property {
        isNil(child.1) ? guess(child.0!, value: child.1) : {
            Mirror(reflecting: child.1).displayStyle == .optional ? .Optional($0) : $0
        } (found(child.0!, value: child.1))
    }
    
    private func found(_ name: String, value: Any) -> Property {
        switch value {
        case is String: return .String(name)
        case is Int: return .Int(name)
        case is Double: return .Double(name)
        case is [String]: return .Array(.String(name))
        default: return .Custom(name)
        }
    }
    
    private func guess(_ name: String, value: Any) -> Property {
        var a: String? = cast(value)
        return .Custom(name)
    }
    
    private func isNil(_ value: Any) -> Bool {
        nil == { cast(value) } () as Any?
    }
    
    private func cast<T>(_ value: Any) -> T {
        value as! T
    }
}

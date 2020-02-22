import Foundation

extension Mirror {
    var reflect: Set<Property> {
        children.reduce(into: .init()) {
            $0.insert(Mirror(reflecting: $1.value).displayStyle == .optional ? .Optional(property($1)) : property($1))
        }
    }
    
    private func property(_ child: (String?, Any)) -> Property {
        switch child.1 {
        case is String: return .String(child.0!)
        case is Int: return .Int(child.0!)
        case is Double: return .Double(child.0!)
        case is [String]: return .Array(.String(child.0!))
        default: return .Custom(child.0!)
        }
        // case let a where (a as? String) == Optional<String>.none: $0[label] = .optionalString
    }
}

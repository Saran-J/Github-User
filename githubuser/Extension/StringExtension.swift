import Foundation

@inlinable
func toInt(_ value: Int?) -> Int {
    if let value = value {
        return value
    }
    return 0
}

@inlinable
func toString(_ value: String?) -> String {
    if let value = value {
        return String(value)
    }
    return ""
}

@inlinable
func toBool(_ value: Bool?) -> Bool {
    if let value = value {
        return value
    }
    return false
}

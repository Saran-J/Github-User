import Foundation

@inlinable
func toString(_ value: String?) -> String {
    if let value = value {
        return String(value)
    }
    return ""
}

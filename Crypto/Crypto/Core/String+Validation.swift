import Foundation

public extension String {

    public func isEmail() -> Bool {
        return match(Regex.email.pattern)
    }

    public func isNumber() -> Bool {
        return match(Regex.number.pattern)
    }
}

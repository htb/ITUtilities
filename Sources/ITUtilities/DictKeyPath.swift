//
// Credits: Ole Begemann
// https://oleb.net/blog/2017/01/dictionary-key-paths/
//

import Foundation


public struct DictKeyPath
{
    var segments: [String]

    var isEmpty: Bool { return segments.isEmpty }
    var path: String {
        return segments.joined(separator: ".")
    }

    /// Strips off the first segment and returns a pair
    /// consisting of the first segment and the remaining key path.
    /// Returns nil if the key path has no segments.
    func headAndTail() -> (head: String, tail: DictKeyPath)? {
        guard !isEmpty else { return nil }
        var tail = segments
        let head = tail.removeFirst()
        return (head, DictKeyPath(segments: tail))
    }
}

extension DictKeyPath
{
    public init(_ string: String) { segments = string.components(separatedBy: ".") }
}

extension DictKeyPath: ExpressibleByStringLiteral
{
    public init(stringLiteral value: String) { self.init(value) }
    public init(unicodeScalarLiteral value: String) { self.init(value) }
    public init(extendedGraphemeClusterLiteral value: String) { self.init(value) }
}

// Needed because Swift 3.0 doesn't support extensions with concrete
// same-type requirements (extension Dictionary where Key == String).
public protocol StringProtocol {
    init(fromString s: String)
}

extension String: StringProtocol {
    public init(fromString s: String) { self = s }
}

extension Dictionary where Key: StringProtocol
{
    subscript(keyPath keyPath: DictKeyPath) -> Any?
    {
        get
        {
            switch keyPath.headAndTail() {
            case nil:
                // key path is empty.
                return nil
            case let (head, remainingKeyPath)? where remainingKeyPath.isEmpty:
                // Reached the end of the key path.
                let key = Key(fromString: head)
                return self[key]
            case let (head, remainingKeyPath)?:
                // Key path has a tail we need to traverse.
                let key = Key(fromString: head)
                switch self[key] {
                case let nestedDict as [Key: Any]:
                    // Next nest level is a dictionary.
                    // Start over with remaining key path.
                    return nestedDict[keyPath: remainingKeyPath]
                default:
                    // Next nest level isn't a dictionary.
                    // Invalid key path, abort.
                    return nil
                }
            }
        }

        set
        {
            switch keyPath.headAndTail() {
            case nil:
                // key path is empty.
                return
            case let (head, remainingKeyPath)? where remainingKeyPath.isEmpty:
                // Reached the end of the key path.
                let key = Key(fromString: head)
                self[key] = newValue as? Value
            case let (head, remainingKeyPath)?:
                let key = Key(fromString: head)
                let value = self[key]
                switch value {
                case var nestedDict as [Key: Any]:
                    // Key path has a tail we need to traverse
                    nestedDict[keyPath: remainingKeyPath] = newValue
                    self[key] = nestedDict as? Value
                default:
                    // Invalid keyPath
                    return
                }
            }
        }
    }
}

extension Dictionary where Key: StringProtocol
{
    subscript(string keyPath: DictKeyPath) -> String?
    {
        get { return self[keyPath: keyPath] as? String }
        set { self[keyPath: keyPath] = newValue }
    }

    subscript(dict keyPath: DictKeyPath) -> [Key: Any]?
    {
        get { return self[keyPath: keyPath] as? [Key: Any] }
        set { self[keyPath: keyPath] = newValue }
    }
}

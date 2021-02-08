import UIKit


extension String
{
    public func fromBase64() -> String?
    {
        guard let data = Data(base64Encoded: self) else {
            return nil
        }
        return String(data: data, encoding: .utf8)
    }

    public func toBase64() -> String
    {
        return Data(self.utf8).base64EncodedString()
    }
    public func textSize(_ font: UIFont) -> CGSize {
        let string:NSString = self as NSString
        return string.size(withAttributes: [.font : font])
    }
}


// Subscript indexing

public extension String
{
    subscript(value: CountableClosedRange<Int>) -> Substring
    {
        get {
            return self[index(at: value.lowerBound)...index(at: value.upperBound)]
        }
    }

    subscript(value: CountableRange<Int>) -> Substring
    {
        get {
            return self[index(at: value.lowerBound)..<index(at: value.upperBound)]
        }
    }

    subscript(value: PartialRangeUpTo<Int>) -> Substring
    {
        get {
            return self[..<index(at: value.upperBound)]
        }
    }

    subscript(value: PartialRangeThrough<Int>) -> Substring
    {
        get {
            return self[...index(at: value.upperBound)]
        }
    }

    subscript(value: PartialRangeFrom<Int>) -> Substring
    {
        get {
            return self[index(at: value.lowerBound)...]
        }
    }

    subscript(value: Int) -> Character
    {
        get {
            return self[index(at: value)]
        }
    }

    func index(at offset: Int) -> String.Index
    {
        return index(startIndex, offsetBy: offset)
    }
}


// Capitalization

extension String
{
    public var capitalizedFirstLetter: String
    {
        return prefix(1).uppercased() + dropFirst()
    }

    public mutating func capitalizeFirstLetter()
    {
        self = self.capitalizedFirstLetter
    }
}


// Trimming

extension String
{
    public func trim() -> String
    {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}


// Misc

extension String
{
    public static func isNilOrEmpty(_ s: String?) -> Bool
    {
        return (s == nil) || s!.isEmpty
    }
}

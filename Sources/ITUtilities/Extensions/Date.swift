import Foundation


extension Date
{
    public func format(_ format: String) -> String
    {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}

extension ISO8601DateFormatter
{
    public convenience init(_ formatOptions: Options, timeZone: TimeZone = TimeZone(secondsFromGMT: 0)!) {
        self.init()
        self.formatOptions = formatOptions
        self.timeZone = timeZone
    }
}

extension Date
{
    public static func from(iso8601String dateString: String) -> Date?
    {
        return
            ISO8601DateFormatter([.withInternetDateTime]).date(from: dateString) ??
            ISO8601DateFormatter([.withFractionalSeconds, .withInternetDateTime]).date(from: dateString)
    }
}

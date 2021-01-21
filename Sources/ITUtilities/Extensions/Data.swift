import Foundation


extension Data
{
    public init?<T: Encodable>(_ encodable: T)
    {
        do {
            self = try JSONEncoder().encode(encodable)
        } catch {
            return nil
        }
    }

    public func decode<T: Decodable>() -> T?
    {
        return try? JSONDecoder().decode(T.self, from: self)
    }
}

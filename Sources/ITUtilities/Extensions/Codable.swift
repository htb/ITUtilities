import Foundation


extension Encodable
{
    public func jsonEncoded() throws -> Data
    {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        return try encoder.encode(self)
    }
}

extension Decodable
{
    public static func jsonDecoded(from data: Data) throws -> Self
    {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode(Self.self, from: data)
    }
}

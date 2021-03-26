import Foundation


struct RuntimeError: Error
{
    let message: String
    let tag: String?

    init(_ message: String, tag: String? = nil)
    {
        self.message = message
        self.tag = tag
    }

    // Error protocol
    public var localizedDescription: String { return message }

    // For non-localized description when using '(error as NSError).description'
    public var description: String { return message }
}

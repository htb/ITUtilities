import Foundation


public extension Array where Element: Equatable
{
    mutating func append(_ newElements: [Element])
    {
        for element in newElements{
            self.append(element)
        }
    }

    /// Remove first collection element that is equal to the given `object`:
    @discardableResult
    mutating func removeFirst(_ object: Element) -> Element?
    {
        if let index = firstIndex(of: object) {
            return remove(at: index)
        }
        return nil
    }
}

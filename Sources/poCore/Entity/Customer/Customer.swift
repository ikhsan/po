import Foundation
import SwiftyJSON

public struct Customer {
    public let id: String
    public let name: String
    public let phone: String
}

extension Customer: Equatable {}

public func ==(lhs: Customer, rhs: Customer) -> Bool {
    return lhs.id == rhs.id && lhs.name == rhs.name && lhs.phone == rhs.phone
}

extension Customer {
    public static func parse(json: JSON) -> Customer? {
        return nil
    }    
}

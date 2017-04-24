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
        guard
            let dictionary = json.dictionary,
            let key = Array(dictionary.keys).first,
            let userJson = dictionary[key]
        else { return nil }

        guard let name = userJson["name"].string else { return nil }
        guard let phone = userJson["phone"].string else { return nil }

        return Customer(id: key, name: name, phone: phone)
    }

    public var json: JSON {
        return JSON([
            "name": name,
            "phone": phone,
        ])
    }
    
}

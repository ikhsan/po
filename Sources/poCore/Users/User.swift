import Foundation
import SwiftyJSON

public struct User {
    public let id: String
    public let name: String
    public let phone: String
    public let email: String
}

extension User: Equatable {}

public func ==(lhs: User, rhs: User) -> Bool {
    return lhs.id == rhs.id && lhs.name == rhs.name && lhs.phone == rhs.phone && lhs.email == rhs.email
}

extension User {
    public static func parse(json: JSON) -> User? {
        guard
            let dictionary = json.dictionary,
            let key = Array(dictionary.keys).first,
            let userJson = dictionary[key]
        else { return nil }

        guard let name = userJson["name"].string else { return nil }
        guard let phone = userJson["phone"].string else { return nil }
        guard let email = userJson["email"].string else { return nil }

        return User(id: key, name: name, phone: phone, email: email)
    }

    public var json: JSON {
        return [
            "id": self.id,
            "name": self.name,
            "phone": self.phone,
            "email": self.email,
        ]
    }
}

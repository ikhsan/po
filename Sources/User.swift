import Foundation
import SwiftyJSON

public struct User {
    let id: String
    let name: String
    let phone: String
    let email: String
}

extension User {
    public init(id: String, json: JSON) {
        self.id = id
        self.name = json["name"].stringValue
        self.phone = json["phone"].stringValue
        self.email = json["email"].stringValue
    }

    public var json: JSON {
        return [
            "name": self.name,
            "phone": self.phone,
            "email": self.email,
        ]
    }
}

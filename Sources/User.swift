import Foundation
import SwiftyJSON

struct User {
    let name: String
    let phone: String
    let email: String
}

extension User {
    init(json: JSON) {
        self.name = json["name"].stringValue
        self.phone = json["phone"].stringValue
        self.email = json["email"].stringValue
    }

    var json: JSON {
        return [
            "name": self.name,
            "phone": self.phone,
            "email": self.email,
        ]
    }
}

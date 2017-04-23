import Foundation
import SwiftyJSON

public struct UserController {

    let api: POAPI
    public init(api: POAPI) {
        self.api = api
    }

    public func getAllUser() throws -> [User] {
        guard let usersDictionary = try api.get(.users).dictionary else { return [] }
        let usersJson: [JSON] = usersDictionary.reduce([]) { $0 + [ JSON([$1.key : $1.value]) ] }
        return usersJson.flatMap(User.parse(json:))
    }

    public func getUser(_ id: String) throws -> User {
        let userJson = try api.get(.user(userId: id))
        let json = JSON([ id : userJson ])

        guard let user = User.parse(json: json) else {
            throw POError(message: "Can't parse user json")
        }

        return user
    }

    public func addUser(_ json: JSON) throws -> JSON {
        return try api.post(.users, body: json)
    }

}

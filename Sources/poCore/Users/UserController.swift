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


    //print("--- Yeah ----")
    //
    //let poApi = POAPI()
    //
    //do {
    //    let userResponse = try poApi.get(.users)
    //    let users = Array(userResponse.dictionaryValue.values)
    //    let xxx = users.map(User.init(json:))
    //    print(xxx)
    //
    //    let user = User(name: "Ikhsan", phone: "071234567", email: "ikhsan@test.com")
    //    let xxx = try poApi.post(.users, body: user.json)
    //    print(xxx["name"].stringValue)
    //
    //} catch {
    //    print("🤕")
    //}

}

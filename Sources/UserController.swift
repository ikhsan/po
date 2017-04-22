import Foundation
import SwiftyJSON

struct UserController {

    let api: POAPI

    func getAllUser() throws -> [User] {
        let userDictionary = try api.get(.users).dictionaryValue
        let users = userDictionary.map { User(id: $0, json: $1) }
        return users
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

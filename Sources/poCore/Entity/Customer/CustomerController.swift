import Foundation
import SwiftyJSON

public struct CustomerController {

    let api: POAPI
    public init(api: POAPI) {
        self.api = api
    }

    public func getAllCustomer() throws -> [Customer] {
        guard let customersDictionary = try api.get(.customers).dictionary else { return [] }
        let customersJson: [JSON] = customersDictionary.reduce([]) {
            $0 + [ JSON([$1.key : $1.value]) ]
        }
        return customersJson.flatMap(Customer.parse(json:))
    }

    public func getCustomer(_ id: String) throws -> Customer {
        let customerJson = try api.get(.customer(userId: id))
        let json = JSON([ id : customerJson ])

        guard let user = Customer.parse(json: json) else {
            throw POError(message: "Can't parse user json")
        }
        
        return user
    }

    public func addCustomer(_ json: JSON) throws -> JSON {
        return try api.post(.customers, body: json)
    }

}

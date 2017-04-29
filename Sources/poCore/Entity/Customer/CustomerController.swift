import Foundation
import SwiftyJSON

public struct CustomerController {

    let api: Sheets
    public init(api: Sheets) {
        self.api = api
    }

    public func getAllCustomer() throws -> [Customer] {
        return []
    }

//    public func getCustomer(_ id: String) throws -> Customer {}
//    public func addCustomer(_ customer: Customer) throws -> String {}
//    public func deleteCustomer(_ customerId: String) throws -> String {}

}

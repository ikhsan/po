import Foundation
import SwiftyJSON

public struct CustomerController {

    let sheets: Sheets
    public init(api: Sheets) {
        self.sheets = api
    }

    public func getAllCustomer() throws -> [Customer] {
        let json = try sheets.getValue(forSheetId: Keys.sheetsId, name: Keys.sheetCustomer)
        let customers = json.arrayValue.flatMap { try? Customer.parse(json: $0) }
        return customers
    }

//    public func getCustomer(_ id: String) throws -> Customer {}
//    public func addCustomer(_ customer: Customer) throws -> String {}
//    public func deleteCustomer(_ customerId: String) throws -> String {}

}

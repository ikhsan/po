import Foundation
import SwiftyJSON

public struct CustomerController {

    let sheets: Sheets
    let orderController: OrderController
    public init(api: Sheets, orderController: OrderController) {
        self.sheets = api
        self.orderController = orderController
    }

    public func fetchAllCustomers() throws -> [Customer] {
        let json = try sheets.getValue(forSheetId: Keys.sheetsId, name: Keys.sheetCustomer)
        return json.arrayValue.flatMap { try? Customer.parse(json: $0) }
    }

    public func getAllCustomer() throws -> Page {
        let customers = try fetchAllCustomers()
        return Page(template: "customers", context: [ "customers" : customers ])
    }

    public func getCustomer(_ id: String) throws -> Page {
        guard let customer = try fetchAllCustomers().first(where: { $0.id == id })
        else { throw PoError("Can't find customer") }

        

        return Page(template: "customer", context: [ "customer" : customer ])
    }

}



import Foundation
import SwiftyJSON

public struct OrderController {

    let sheets: Sheets
    public init(api: Sheets) {
        self.sheets = api
    }

    public func fetchAllOrders() throws -> [Order] {
        let json = try sheets.getValue(forSheetId: Keys.sheetsId, name: Keys.sheetOrder)

        let orders: [Order] = json.arrayValue.reduce([]) { (result, json) -> [Order] in
            var customerJson = json.arrayValue
            if let hasNoCustomer = customerJson.first?.stringValue.isEmpty,
                hasNoCustomer,
                let lastCustomer = result.last?.customer
            {
                customerJson[0] = JSON(lastCustomer)
            }

            guard let newOrder = try? Order.parse(json: JSON(customerJson)) else { return result }
            return result + [ newOrder ]
        }

        return orders
    }

    public func fetchOrder(by customer: Customer) throws -> [Order] {
        return try fetchAllOrders()
            .filter { $0.customer == customer.name }
    }

    public func getAllOrders() throws -> Page {
        let orders = try fetchAllOrders()
        return Page(template: "orders", context: [ "orders" : orders ])
    }
    
}

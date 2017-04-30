import Foundation
import SwiftyJSON

public class CustomerRepository {

    let sheets: Sheets
    
    public init(sheets: Sheets) {
        self.sheets = sheets
    }

    public func all() throws -> [Customer] {
        let json = try sheets.getValue(forSheetId: Keys.sheetsId, name: Keys.sheetCustomer)
        return json.arrayValue.flatMap { try? Customer.parse(json: $0) }
    }

    public func get(id: String) throws -> Customer {
        guard let customer = try self.all().first(where: { $0.id == id }) else {
            throw PoError("Can't find customer")
        }
        return customer
    }

}

public class OrderRepository {

    let sheets: Sheets

    public init(sheets: Sheets) {
        self.sheets = sheets
    }

    public func all() throws -> [Order] {
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

    public func all(by customer: Customer) throws -> [Order] {
        return try self.all().filter { $0.customer == customer.name }
    }
    
}

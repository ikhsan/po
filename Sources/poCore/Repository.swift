import Foundation
import SwiftyJSON

public class CustomerRepository {

    let sheets: Sheets
    
    public init(sheets: Sheets) {
        self.sheets = sheets
    }

    public func all() throws -> [Customer] {
        let json = try sheets.getValue(forSheetId: Config.sheetsId, name: Config.sheetCustomer)
        return json.arrayValue.flatMap { try? Customer.parse(json: $0) }.unique()
    }

    public func get(id: String) throws -> Customer {
        guard let customer = try self.all().first(where: { $0.id == id }) else {
            throw PoError("Can't find customer")
        }
        return customer
    }

    public func get(name: String) throws -> Customer {
        guard let customer = try self.all().first(where: { $0.name == name }) else {
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
        let json = try sheets.getValue(forSheetId: Config.sheetsId, name: Config.sheetOrder)

        let orders: [Order] = json.arrayValue.reduce([]) { (result, json) -> [Order] in
            var ordersJson = json.arrayValue
            if let hasNoCustomer = ordersJson.first?.stringValue.isEmpty,
                hasNoCustomer,
                let lastCustomer = result.last?.customer
            {
                ordersJson[0] = JSON(lastCustomer)
            }

            guard let newOrder = try? Order.parse(json: JSON(ordersJson)) else { return result }
            return result + [ newOrder ]
        }

        return orders
    }

    public func all(by customer: Customer) throws -> [Order] {
        return try self
            .all()
            .filter { $0.customer.lowercased() == customer.name.lowercased() }
    }
    
}

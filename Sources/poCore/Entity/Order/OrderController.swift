import Foundation
import SwiftyJSON

public struct OrderController {

    let api: POAPI
    public init(api: POAPI) {
        self.api = api
    }

    public func getOrders(forCustomerId customerId: String) throws -> [Order] {
        let ordersDictionary = try api.get(.orders(customerId: customerId)).dictionaryValue
        let customersJson: [JSON] = ordersDictionary.reduce([]) {
            $0 + [ JSON([ $1.key : $1.value ]) ]
        }
        let orders = customersJson.flatMap(Order.parse(json:))

        return orders
    }

    public func addOrder(_ order: Order, forCustomerId customerId: String) throws -> String {
        let result = try api.post(.orders(customerId: customerId), body: order.json)

        let orderId = result["name"].stringValue
        print("Order (\(orderId)) has been created")
        return orderId
    }
    
}

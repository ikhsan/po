import Foundation
import SwiftyJSON

public struct OrderController {

    let ordersRepo: OrderRepository
    let customersRepo: CustomerRepository

    public init(ordersRepo: OrderRepository, customersRepo: CustomerRepository) {
        self.ordersRepo = ordersRepo
        self.customersRepo = customersRepo
    }

    public func getAllOrders() throws -> Page {
        let orders = try ordersRepo
            .all()
            .flatMap { order -> OrderViewModel? in
                guard let customer = try? customersRepo.get(name: order.customer) else { return nil }
                return OrderViewModel(order, customer: customer)
            }

        return Page(template: "orders", context: [
            "orders" : orders
        ])
    }
    
}

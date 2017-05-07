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
        let orders = try ordersRepo.all()
        let orderViewModels = orders.flatMap { order -> OrderViewModel? in
            guard let customer = try? customersRepo.get(name: order.customer) else { return nil }
            return OrderViewModel(order, customer: customer)
        }

        let pendingOrders = orders.filter { $0.status == .pending }
        let orderedOrders = orders.filter { $0.status != .pending }

        func sum(_ orders: [Order]) -> Double {
            return orders.map { $0.buyPrice }.reduce(0.0, +)
        }

        let pendingTransaction = sum(pendingOrders)
        let orderedTransaction = sum(orderedOrders)
        let totalTransaction = sum(orders)

        return Page(template: "orders", context: [
            "orders" : orderViewModels,
            "pendingTransaction" : Pound.render(pendingTransaction),
            "orderedTransaction" : Pound.render(orderedTransaction),
            "totalTransaction" : Pound.render(totalTransaction),
        ])
    }
    
}

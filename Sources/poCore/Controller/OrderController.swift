import Foundation
import SwiftyJSON

public struct OrderController {

    let orderRepository: OrderRepository

    public init(orderRepository: OrderRepository) {
        self.orderRepository = orderRepository
    }

    public func getAllOrders() throws -> Page {
        let orders = try orderRepository.all()
        return Page(template: "orders", context: [
            "orders" : orders
        ])
    }
    
}

import Foundation
import SwiftyJSON

public struct CustomerController {

    let customersRepo: CustomerRepository
    let ordersRepo: OrderRepository

    public init(customersRepo: CustomerRepository, ordersRepo: OrderRepository) {
        self.customersRepo = customersRepo
        self.ordersRepo = ordersRepo
    }

    public func getAllCustomers() throws -> Page {
        let customers = try customersRepo.all()
        return Page(template: "customers", context: [
            "customers" : customers
        ])
    }

    public func getCustomer(_ id: String) throws -> Page {
        let customer = try customersRepo.get(id: id)
        let orders = try ordersRepo.all(by: customer)

        let orderViewModels = orders.map { OrderViewModel($0, customer: customer) }
        let totalItem = orders
            .flatMap { $0.quantity }
            .reduce(0, +)
        let totalPrice = orders
            .flatMap { $0.sellPrice }
            .reduce(0, +)

        return Page(template: "customer", context: [
            "customer" : customer,
            "orders" : orderViewModels,
            "totalItem" : totalItem,
            "totalPrice" : Rupiah.render(totalPrice, stripped: true),
        ])
    }

}



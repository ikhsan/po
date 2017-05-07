import Foundation
import SwiftyJSON

public struct CustomerController {

    let customersRepo: CustomerRepository
    let ordersRepo: OrderRepository
    let paymentRepo: PaymentRepository

    public init(customersRepo: CustomerRepository, ordersRepo: OrderRepository, paymentRepo: PaymentRepository) {
        self.customersRepo = customersRepo
        self.ordersRepo = ordersRepo
        self.paymentRepo = paymentRepo
    }

    public func getAllCustomers() throws -> Page {
        let customers = try customersRepo.all()
        return Page(template: "customers", context: [
            "customers" : customers
        ])
    }

    public func getCustomer(_ id: String, isPublicLink: Bool = false) throws -> Page {
        let customer = try customersRepo.get(id: id)
        let orders = try ordersRepo.all(by: customer)
        let orderViewModels = orders.map { OrderViewModel($0, customer: customer) }

        let totalItem = orders
            .flatMap { $0.quantity }
            .reduce(0, +)
        let totalPrice = orders
            .flatMap { $0.sellPrice * Double($0.quantity) }
            .reduce(0, +)

        let template = !isPublicLink ? "customer" : "public_customer"
        var context: [String : Any] = [
            "customer" : customer,
            "orders" : orderViewModels,
            "totalItem" : totalItem,
            "totalPrice" : Rupiah.render(totalPrice, stripped: true)
        ]

        let payments = try paymentRepo.all(by: customer)
        context["payments"] = payments.map { PaymentViewModel($0, customer: customer) }

        let totalPayment: Double = payments.map { $0.deposit }.reduce(0, +)
        context["totalPayment"] = Rupiah.render(totalPayment, stripped: true)

        let totalDebt = totalPrice - totalPayment
        context["totalDebt"] = Rupiah.render(totalDebt, stripped: true)

        return Page(template: template, context: context)
    }

}



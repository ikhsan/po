import Foundation

public class OrderViewModel {
    private let order: Order
    private let customer: Customer

    public let status: String
    public let statusClass: String
    public let productName: String
    public let productPrice: String
    public let productQuantity: String
    public let totalPrice: String
    public let customerName: String
    public let customerId: String

    public init(_ order: Order, customer: Customer) {
        self.order = order

        self.status = OrderViewModel.renderStatus(order.status)
        self.statusClass = order.status.rawValue
        self.productName = order.productName
        self.productPrice = Rupiah.render(order.sellPrice)
        self.productQuantity = "\(order.quantity)"
        self.totalPrice = Rupiah.render(Double(order.quantity) * order.sellPrice, stripped: true)

        self.customer = customer
        self.customerName = customer.name
        self.customerId = customer.id
    }

    private static func renderStatus(_ status: Order.Status) -> String {
        let emoji: String
        switch status {
        case .pending: emoji = "❓"
        case .ordered: emoji = "💳"
        case .delivered: emoji = "📦"
        }
        return "\(emoji)"
    }
}

public class CustomersOrdersViewModel {
    private let order: Order

    public init(_ order: Order) {
        self.order = order
    }
}

public class PaymentViewModel {
    private let payment: Payment
    private let customer: Customer

    public let date: String
    public let deposit: String

    public init(_ payment: Payment, customer: Customer) {
        self.payment = payment
        self.customer = customer

        self.deposit = Rupiah.render(payment.deposit, stripped: true)
        self.date = PaymentDate.renderMediumDate(payment.date)
    }
}

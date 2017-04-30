import Foundation
import SwiftyJSON

public struct Order {
    public enum Status: String {
        case pending
        case ordered
        case delivered
    }

    public let customer: String
    public let productName: String
    public var buyPrice: Double
    public var quantity: Int
    public var sellPrice: Double
    public var status: Status

    public init(
        customer: String,
        productName: String,
        buyPrice: Double,
        sellPrice: Double,
        quantity: Int = 1,
        status: Status = .pending
    ) {
        self.customer = customer
        self.productName = productName
        self.buyPrice = buyPrice
        self.sellPrice = sellPrice
        self.quantity = quantity
        self.status = status
    }

}

extension Order: Equatable {}

public func ==(lhs: Order, rhs: Order) -> Bool {
    return lhs.customer == rhs.customer &&
        lhs.productName == rhs.productName &&
        lhs.buyPrice == rhs.buyPrice &&
        lhs.sellPrice == rhs.sellPrice &&
        lhs.quantity == rhs.quantity &&
        lhs.status == rhs.status
}

extension Order {
    public static func parse(json: JSON) throws -> Order {
        let parsingError = PoError("Parsing Order errored")
        guard let array = json.array else { throw parsingError }

        guard !array.isEmpty,
            let customer = array[0].string,
            !customer.isEmpty
            else { throw parsingError }
        guard array.count > 1,
            let productName = array[1].string,
            !productName.isEmpty
            else { throw parsingError }
        guard array.count > 2,
            let quantityString = array[2].string,
            let quantity = Int(quantityString)
            else { throw parsingError }
        guard array.count > 3,
            let buyPriceString = array[3].string,
            let buyPrice = Double(buyPriceString)
            else { throw parsingError }
        guard array.count > 5,
            let sellPriceString = array[5].string?.replacingOccurrences(of: ",", with: ""),
            let sellPrice = Double(sellPriceString)
            else { throw parsingError }

        let isOrdered = array.count > 8 ? array[8].stringValue : ""
        let isDelivered = array.count > 9 ? array[9].stringValue : ""

        let status: Order.Status
        switch (isOrdered, isDelivered) {
        case ("✅", "✅"):
            status = .delivered
        case ("✅", ""):
            status = .ordered
        default:
            status = .pending
        }

        return Order(customer: customer, productName: productName, buyPrice: buyPrice, sellPrice: sellPrice, quantity: quantity, status: status)
    }
}

import Foundation
import SwiftyJSON

public struct Order {
    public let id: String
    public let productName: String
    public var buyPrice: Double
    public var sellPrice: Double
    public var quantity: Int
    public var isOrdered: Bool
    public var isDelivered: Bool

    public init(
        id: String,
        productName: String,
        buyPrice: Double,
        sellPrice: Double = 0,
        quantity: Int = 1,
        isOrdered: Bool = false,
        isDelivered: Bool = false
    ) {
        self.id = id
        self.productName = productName
        self.buyPrice = buyPrice
        self.sellPrice = sellPrice
        self.quantity = quantity
        self.isOrdered = isOrdered
        self.isDelivered = isDelivered
    }

}

extension Order: Equatable {}

public func ==(lhs: Order, rhs: Order) -> Bool {
    return lhs.id == rhs.id && lhs.productName == rhs.productName && lhs.buyPrice == rhs.buyPrice && lhs.quantity == rhs.quantity && lhs.isOrdered == rhs.isOrdered && lhs.isDelivered == rhs.isDelivered
}

extension Order {
    public static func parse(json: JSON) -> Order? {
        guard
            let dictionary = json.dictionary,
            let key = Array(dictionary.keys).first,
            let orderJson = dictionary[key]
            else { return nil }

        guard let productName = orderJson["productName"].string else { return nil }
        guard let buyPrice = orderJson["buyPrice"].double else { return nil }

        var order = Order(id: key, productName: productName, buyPrice: buyPrice)
        order.quantity = orderJson["quantity"].int ?? order.quantity
        order.sellPrice = orderJson["sellPrice"].double ?? order.sellPrice
        order.isOrdered = orderJson["isOrdered"].bool ?? order.isOrdered
        order.isDelivered = orderJson["isDelivered"].bool ?? order.isDelivered
        return order
    }

    public var json: JSON {
        return JSON([
            "productName": productName,
            "quantity": quantity,
            "buyPrice": buyPrice,
            "sellPrice": sellPrice,
            "isOrdered": isOrdered,
            "isDelivered": isDelivered,
        ])
    }
    
}

import Kitura
import SwiftyJSON

public struct OrderRouterFactory {

    public static func create(
        orderController: OrderController,
        customerController: CustomerController
    ) -> Router {
        let router = Router()

        router.get("customer/:customerId") { request, response, next in
            guard let customerId = request.parameters["customerId"] else {
                return try response.redirect("/").end()
            }

            let customer = try customerController.getCustomer(customerId)
            let orders = try orderController.getOrders(forCustomerId: customer.id)

            try response.render("orders.stencil", context: [
                "customer": customer,
                "orders" : orders
            ])
            next()
        }

        router.all("customer/:customerId/add", middleware: BodyParser())
        router.get("customer/:customerId/add") { request, response, next in
            guard let customerId = request.parameters["customerId"] else {
                return try response.redirect("/").end()
            }
            let customer = try customerController.getCustomer(customerId)
            try response.render("order_add.stencil", context: [ "customer" : customer ])
            next()
        }

        router.post("customer/:customerId/add") { request, response, next in
            guard let customerId = request.parameters["customerId"] else {
                return try response.redirect("/").end()
            }

            guard
                let body = request.body?.asURLEncoded,
                let productName = body["productName"],
                let buyPrice = body["buyPrice"]
            else {
                try response.redirect("/")
                return next()
            }

            var order = Order(id: "", productName: productName, buyPrice: Double(buyPrice) ?? 0)
            if let quantityString = body["quantity"], let quantity = Int(quantityString) {
                order.quantity = quantity
            }
            if let sellPriceString = body["sellPrice"], let sellPrice = Double(sellPriceString) {
                order.sellPrice = sellPrice
            }
            if let isOrderedString = body["isOrdered"], let isOrdered = Bool(isOrderedString) {
                order.isOrdered = isOrdered
            }
            if let isDeliveredString = body["isDelivered"], let isDelivered = Bool(isDeliveredString) {
                order.isDelivered = isDelivered
            }

            _ = try orderController.addOrder(order, forCustomerId: customerId)

            try response.redirect("/customers/\(customerId)")
            next()
        }

//        router.get("/:customerId") { request, response, next in
//            guard let customerId = request.parameters["customerId"] else {
//                try response.redirect("/")
//                return next()
//            }
//
//            let customer = try orderController.getCustomer(customerId)
//            let context = [ "customer" : customer ]
//            try response.render("customer.stencil", context: context)
//            next()
//        }

        return router
    }

}

import Kitura
import SwiftyJSON

public struct OrderRouterFactory {

    public static func create(_ orderController: OrderController) -> Router {
        let router = Router()

        router.get("/") { request, response, next in
            let orders = try orderController.getAllOrders()
            try response.render("orders.stencil", context: [ "orders" : orders ])
            next()
        }

        return router
    }

}

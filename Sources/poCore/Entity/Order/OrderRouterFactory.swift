import Kitura
import SwiftyJSON

public struct OrderRouterFactory {

    public static func create(_ orderController: OrderController) -> Router {
        let router = Router()

        router.get("/") { request, response, next in
            let page = try orderController.getAllOrders()
            try response.renderStencilPage(page)
            next()
        }

        return router
    }

}

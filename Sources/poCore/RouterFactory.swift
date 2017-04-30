import Kitura
import SwiftyJSON

public struct CustomerRouterFactory {

    public static func create(_ customerController: CustomerController) -> Router {
        let router = Router()

        router.get("/") { request, response, next in
            let page = try customerController.getAllCustomers()
            try response.renderStencilPage(page)
            next()
        }

        let customerId = "customerId"
        router.get("/:\(customerId)") { request, response, next in
            let id = request.parameters[customerId] ?? ""

            let page = try customerController.getCustomer(id)
            try response.renderStencilPage(page)
            next()
        }

        return router
    }
    
}

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

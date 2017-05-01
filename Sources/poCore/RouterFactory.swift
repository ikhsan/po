import Kitura

public struct RouterFactory {

    public static func customerRouter(_ customerController: CustomerController) -> Router {
        let router = Router()

        router.get("/") { request, response, next in
            guard request.userProfile != nil else {
                try response.redirect("/login")
                return next()
            }

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
    

    public static func orderRouter(_ orderController: OrderController) -> Router {
        let router = Router()

        router.get("/") { request, response, next in
            guard request.userProfile != nil else {
                try response.redirect("/login")
                return next()
            }

            let page = try orderController.getAllOrders()
            try response.renderStencilPage(page)
            next()
        }

        return router
    }

}

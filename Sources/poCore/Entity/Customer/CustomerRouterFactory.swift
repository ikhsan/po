import Kitura
import SwiftyJSON

public struct CustomerRouterFactory {

    public static func create(_ customerController: CustomerController) -> Router {
        let router = Router()

        router.get("/") { request, response, next in
            let customers = try customerController.getAllCustomer()
            try response.render("customers.stencil", context: [ "customers" : customers ])
            next()
        }

        router.get("/:customerId") { request, response, next in
            response.send("to be implemented")
            next()
        }

        return router
    }

}

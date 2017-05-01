import Kitura

public struct RouterFactory {

    public static func customerRouter(_ customerController: CustomerController) -> Router {
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
    

    public static func orderRouter(_ orderController: OrderController) -> Router {
        let router = Router()

        router.get("/") { request, response, next in
            let page = try orderController.getAllOrders()
            try response.renderStencilPage(page)
            next()
        }

        return router
    }

}

import Credentials
import CredentialsGoogle

extension RouterFactory {

    public static func setupAuth(for router: Router) {
        let credentials = Credentials()
        let googleCredentials = CredentialsGoogle(
            clientId: Keys.Google.clientId,
            clientSecret: Keys.Google.secret,
            callbackUrl: Keys.Google.callbackUrl,
            options: ["scope" : "email profile"]
        )
        credentials.register(plugin: googleCredentials)
        credentials.options["failureRedirect"] = "/"
        credentials.options["successRedirect"] = "/"

        router.get("/") { request, response, next in
            let isAdmin = false

            let page = isAdmin ? Page(template: "admin", context: [:]) : Page(template: "login", context: [:])
            try response.renderStencilPage(page)
            next()
        }
    }

}

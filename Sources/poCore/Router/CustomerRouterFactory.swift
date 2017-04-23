import Kitura
import SwiftyJSON

public struct CustomerRouterFactory {

    public static func create(customerController: CustomerController) -> Router {
        let router = Router()

        router.get("/") { request, response, next in
            let users = try customerController.getAllCustomer()
            let context = [ "users" : users ]
            try response.render("customers.stencil", context: context)
            next()
        }

        router.get("/:customerId") { request, response, next in
            guard let userId = request.parameters["customerId"] else {
                try response.redirect("/")
                return next()
            }

            let user = try customerController.getCustomer(userId)
            let context = [ "user" : user ]
            try response.render("customer.stencil", context: context)
            next()
        }

        router.all("add", middleware: BodyParser())
        router.get("add") { request, response, next in
            try response.render("customers_add.stencil", context: [:])
            next()
        }

        router.post("add") { request, response, next in
            guard let body = request.body?.asURLEncoded else {
                try response.redirect("/")
                return next()
            }

            let json = JSON(body)
            let result = try customerController.addCustomer(json)

            if let id = result["name"].string {
                print("\(id) user has been created")
            }

            try response.redirect("/")
            next()
        }

        return router
    }

}

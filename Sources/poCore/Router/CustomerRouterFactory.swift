import Kitura
import SwiftyJSON

public struct CustomerRouterFactory {

    public static func create(customerController: CustomerController) -> Router {
        let router = Router()

        router.get("/") { request, response, next in
            let customers = try customerController.getAllCustomer()
            let context = [ "customers" : customers ]
            try response.render("customers.stencil", context: context)
            next()
        }

        router.all("add", middleware: BodyParser())
        router.get("add") { request, response, next in
            try response.render("customers_add.stencil", context: [:])
            next()
        }

        router.post("add") { request, response, next in
            guard
                let body = request.body?.asURLEncoded,
                let name = body["name"],
                let phone = body["phone"]
            else {
                try response.redirect("/customers")
                return next()
            }

            let customer = Customer(id: "", name: name, phone: phone)
            _ = try customerController.addCustomer(customer)

            try response.redirect("/customers")
            next()
        }

        router.get("/:customerId") { request, response, next in
            guard let customerId = request.parameters["customerId"] else {
                try response.redirect("/")
                return next()
            }

            let customer = try customerController.getCustomer(customerId)
            let context = [ "customer" : customer ]
            try response.render("customer.stencil", context: context)
            next()
        }

        return router
    }

}

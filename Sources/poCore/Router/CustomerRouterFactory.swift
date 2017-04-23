import Kitura
import SwiftyJSON

public struct CustomerRouterFactory {

    public static func create(userController: UserController) -> Router {
        let router = Router()

        router.get("/") { request, response, next in
            let users = try userController.getAllUser()
            let context = [ "users" : users ]
            try response.render("customers.stencil", context: context)
            next()
        }

        router.get(":userId") { request, response, next in
            guard let userId = request.parameters["userId"] else {
                try response.redirect("/customers")
                return next()
            }

            let user = try userController.getUser(userId)
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
                try response.redirect("/customers")
                return next()
            }

            let json = JSON(body)
            let result = try userController.addUser(json)

            if let id = result["name"].string {
                print("\(id) user has been created")
            }

            try response.redirect("/customers")
            next()
        }

        return router
    }

}

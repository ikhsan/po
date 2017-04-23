import Kitura
import KituraStencil
import HeliumLogger
import SwiftyJSON
import poCore

HeliumLogger.use()

let api = POAPI()
let userController = UserController(api: api)

let router = Router()

router.all("/", middleware: StaticFileServer())
router.add(templateEngine: StencilTemplateEngine())

router.get("/") { request, response, next in
    try response.render("admin.stencil", context: [:])
    next()
}

router.get("/customers") { request, response, next in
    let users = try userController.getAllUser()
    let context = [ "users" : users ]
    try response.render("customers.stencil", context: context)
    next()
}

router.get("/customers/add") { request, response, next in
    try response.render("customers_add.stencil", context: [:])
    next()
}

router.get("/customers/:userId") { request, response, next in
    guard let userId = request.parameters["userId"] else {
        try response.redirect("/customers")
        return next()
    }

    let user = try userController.getUser(userId)
    let context = [ "user" : user ]
    try response.render("customer.stencil", context: context)
    next()
}

router.all("/customers/add", middleware: BodyParser())
router.post("/customers/add") { request, response, next in
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

let port = portFromEnv() ?? 8080
Kitura.addHTTPServer(onPort: port, with: router)
Kitura.run()

import Kitura
import KituraStencil
import HeliumLogger
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

let port = portFromEnv() ?? 8080
Kitura.addHTTPServer(onPort: port, with: router)
Kitura.run()

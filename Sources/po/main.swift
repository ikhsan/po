import Kitura
import KituraStencil
import HeliumLogger
import SwiftyJSON
import poCore

HeliumLogger.use()

let api = POAPI()
let customerController = CustomerController(api: api)

let router = Router()

router.all("/", middleware: StaticFileServer())
router.add(templateEngine: StencilTemplateEngine())

router.get("/") { request, response, next in
    try response.render("admin.stencil", context: [:])
    next()
}

let customerRouter = CustomerRouterFactory.create(customerController: customerController)
router.all("customers", middleware: customerRouter)

let port = portFromEnv() ?? 8080
Kitura.addHTTPServer(onPort: port, with: router)
Kitura.run()

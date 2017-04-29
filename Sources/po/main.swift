import Kitura
import KituraStencil
import HeliumLogger
import SwiftyJSON
import poCore

HeliumLogger.use()

let sheets = Sheets(apiKey: Keys.sheetsApiKey)
let orderController = OrderController(api: sheets)

let router = Router()
router.all("/", middleware: StaticFileServer())
router.add(templateEngine: StencilTemplateEngine())

router.get("/") { request, response, next in
    try response.render("admin.stencil", context: [:])
    next()
}

let customerRouter = CustomerRouterFactory.create()
router.all("customers", middleware: customerRouter)

let orderRouter = OrderRouterFactory.create(orderController)
router.all("orders", middleware: orderRouter)

let port = portFromEnv() ?? 8080
Kitura.addHTTPServer(onPort: port, with: router)
Kitura.run()

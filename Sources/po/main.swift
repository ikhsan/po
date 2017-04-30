import Kitura
import KituraStencil
import HeliumLogger
import SwiftyJSON
import poCore

HeliumLogger.use()

// MARK: - Setup controllers
let sheets = Sheets(apiKey: Keys.sheetsApiKey)
let orderRepo = OrderRepository(sheets: sheets)
let orderController = OrderController(orderRepository: orderRepo)

let customerRepo = CustomerRepository(sheets: sheets)
let customerController = CustomerController(customersRepo: customerRepo, ordersRepo: orderRepo)

// MARK: - Router

let router = Router()
router.all("/", middleware: StaticFileServer())
router.add(templateEngine: StencilTemplateEngine())

router.get("/") { request, response, next in
    try response.render("admin.stencil", context: [:])
    next()
}

router.all("orders", middleware: OrderRouterFactory.create(orderController))
router.all("customers", middleware: CustomerRouterFactory.create(customerController))

let port = portFromEnv() ?? 8080
Kitura.addHTTPServer(onPort: port, with: router)
Kitura.run()

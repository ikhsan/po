import Kitura
import KituraStencil
import KituraSession
import HeliumLogger
import poCore

HeliumLogger.use()

// MARK: - Setup controllers
let sheets = Sheets(apiKey: Keys.sheetsApiKey)
let orderRepo = OrderRepository(sheets: sheets)
let customerRepo = CustomerRepository(sheets: sheets)

let orderController = OrderController(ordersRepo: orderRepo, customersRepo: customerRepo)
let customerController = CustomerController(customersRepo: customerRepo, ordersRepo: orderRepo)

// MARK: - Router

let router = Router()
router.all("/", middleware: StaticFileServer())
router.add(templateEngine: StencilTemplateEngine())
router.all(middleware: Session(secret: Keys.sessionSecret))

RouterFactory.setupAuth(for: router)
router.all("orders", middleware: RouterFactory.orderRouter(orderController))
router.all("customers", middleware: RouterFactory.customerRouter(customerController))

let port = portFromEnv() ?? 8080
Kitura.addHTTPServer(onPort: port, with: router)
Kitura.run()

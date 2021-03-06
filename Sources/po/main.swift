import Kitura
import KituraStencil
import KituraSession
import HeliumLogger
import poCore

HeliumLogger.use()

// MARK: - Setup controllers
let sheets = Sheets(apiKey: Config.sheetsApiKey)
let orderRepo = OrderRepository(sheets: sheets)
let customerRepo = CustomerRepository(sheets: sheets)
let paymentRepo = PaymentRepository(sheets: sheets)

let orderController = OrderController(ordersRepo: orderRepo, customersRepo: customerRepo)
let customerController = CustomerController(customersRepo: customerRepo, ordersRepo: orderRepo, paymentRepo: paymentRepo)

// MARK: - Router

let router = Router()
router.all("/", middleware: StaticFileServer())
router.add(templateEngine: StencilTemplateEngine())
router.all(middleware: Session(secret: Config.sessionSecret))

RouterFactory.setupAuth(for: router)
router.all("admin/orders", middleware: RouterFactory.orderRouter(orderController))
router.all("admin/customers", middleware: RouterFactory.privateCustomerRouter(customerController))
router.all("s", middleware: RouterFactory.publicCustomerRouter(customerController))

let port = portFromEnv() ?? 8080
Kitura.addHTTPServer(onPort: port, with: router)
Kitura.run()

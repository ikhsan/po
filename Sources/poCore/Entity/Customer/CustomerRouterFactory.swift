import Kitura
import SwiftyJSON

public struct CustomerRouterFactory {

    public static func create() -> Router {
        let router = Router()

        router.get("/") { request, response, next in
            response.send("to be implemented")
            next()
        }

        router.get("/:customerId") { request, response, next in
            response.send("to be implemented")
            next()
        }

        return router
    }

}

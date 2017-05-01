import Foundation
import Kitura

public struct RouterFactory {

    public static func privateCustomerRouter(_ customerController: CustomerController) -> Router {
        let router = Router()

        router.get("/") { request, response, next in
            guard request.userProfile != nil else {
                try response.redirect("/login")
                return next()
            }

            let page = try customerController.getAllCustomers()
            try response.renderStencilPage(page)
            next()
        }

        let customerId = "customerId"
        router.get("/:\(customerId)") { request, response, next in
            let id = request.parameters[customerId] ?? ""

            var page = try customerController.getCustomer(id)
            if let hostUrl = URL(string: "/", relativeTo: request.urlURL) {
                let publicLink = hostUrl.appendingPathComponent("s/\(id)")
                page.setValue(publicLink.absoluteString, for: "publicLink")
            }

            try response.renderStencilPage(page)
            next()
        }

        return router
    }

    public static func publicCustomerRouter(_ customerController: CustomerController) -> Router {
        let router = Router()
        let customerId = "customerId"
        router.get("/:\(customerId)") { request, response, next in
            guard let id = request.parameters[customerId] else {
                try response.redirect("/")
                return next()
            }

            let page = try customerController.getCustomer(id, isPublicLink: true)
            try response.renderStencilPage(page)
            next()
        }

        return router
    }


    public static func orderRouter(_ orderController: OrderController) -> Router {
        let router = Router()

        router.get("/") { request, response, next in
            guard request.userProfile != nil else {
                try response.redirect("/login")
                return next()
            }

            let page = try orderController.getAllOrders()
            try response.renderStencilPage(page)
            next()
        }
        
        return router
    }
    
}

import Foundation
import Kitura

public struct RouterFactory {

    public static func privateCustomerRouter(_ customerController: CustomerController) -> Router {
        let router = Router()

        router.get("/") { request, response, next in
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

                if let customer = page.context["customer"] as? Customer {
                    let link = Whatsapp.send(
                        "\(customer.name.capitalized), rekapnya ada di sini ya 👉 \(publicLink.absoluteString)",
                        phone: customer.phone
                    )
                    page.setValue("- <a href=\"\(link)\">via Whatsapp</a>", for: "whatsappLink")
                }
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
            let page = try orderController.getAllOrders()
            try response.renderStencilPage(page)
            next()
        }
        
        return router
    }
    
}

import Credentials
import CredentialsGoogle

extension RouterFactory {

    public static func setupAuth(for router: Router) {
        let credentials = Credentials()
        let googleCredentials = CredentialsGoogle(
            clientId: Config.Google.clientId,
            clientSecret: Config.Google.secret,
            callbackUrl: Config.Google.callbackUrl,
            options: ["scope" : "email profile"]
        )
        credentials.register(plugin: googleCredentials)
        credentials.options["failureRedirect"] = "/login"
        credentials.options["successRedirect"] = "/admin"

        let whitelists = WhitelistEmails(Config.emailWhitelist, logoutPath: "/logout")

        router.get("/") { request, response, next in
            let page = Page(template: "home", context: [:])
            try response.renderStencilPage(page)
            next()
        }

        let loginUrl = "/login/google"
        router.get("/login") { request, response, next in
            let page = Page(template: "login", context: [ "loginUrl" : loginUrl ])
            try response.renderStencilPage(page)
            next()
        }

        router.get(loginUrl, handler: credentials.authenticate(credentialsType: googleCredentials.name))
        router.get("/login/callback", handler: credentials.authenticate(credentialsType: googleCredentials.name))
        router.get("/logout") { request, response, next in
            credentials.logOut(request: request)
            try response.redirect("/")
            next()
        }

        router.all("/admin", middleware: credentials, whitelists)
        router.get("/admin") { request, response, next in
            guard let profile = request.userProfile else {
                return next()
            }

            let page = Page(template: "admin", context: [
                "user" : profile,
                "isAdmin" : true
                ])

            try response.renderStencilPage(page)
            next()
        }
    }
    
}

import Foundation
import Kitura
import Credentials
import CredentialsGoogle

extension RouterFactory {

    public static func setupAuth(for router: Router) {
        let credentials = Credentials()
        let googleCredentials = CredentialsGoogle(
            clientId: Keys.Google.clientId,
            clientSecret: Keys.Google.secret,
            callbackUrl: Keys.Google.callbackUrl,
            options: ["scope" : "email profile"]
        )
        credentials.register(plugin: googleCredentials)
        credentials.options["failureRedirect"] = "/login"
        credentials.options["successRedirect"] = "/admin"

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

        router.all("/admin", middleware: credentials)
        router.get("/admin") { request, response, next in
            guard let profile = request.userProfile else {
                try response.redirect("/login")
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

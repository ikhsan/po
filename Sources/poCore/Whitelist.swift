import Foundation
import Kitura
import Credentials

public class WhitelistEmails : RouterMiddleware {

    private let registeredEmails: [String]
    private let logoutPath: String

    public init(_ emails: [String], logoutPath: String) {
        self.registeredEmails = emails
        self.logoutPath = logoutPath
    }

    public func handle(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {
        guard let userEmails = request.userProfile?.emails else {
            return next()
        }

        let emails = userEmails.map { $0.value }
        for email in emails where registeredEmails.contains(email) {
            return next()
        }

        try response.redirect(logoutPath)
        next()
    }
}

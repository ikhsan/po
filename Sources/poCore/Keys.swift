import Foundation

public struct Keys {
    public static let sheetsApiKey = ProcessInfo.processInfo.environment["SHEETS_API_KEY"] ?? ""
    public static let sheetsId = ProcessInfo.processInfo.environment["SHEETS_ID"] ?? ""
    public static let sheetOrder = ProcessInfo.processInfo.environment["SHEET_ORDER_NAME"] ?? ""
    public static let sheetCustomer = ProcessInfo.processInfo.environment["SHEET_CUSTOMER_NAME"] ?? ""

    public struct Google {
        public static let clientId = ProcessInfo.processInfo.environment["GOOGLE_CLIENT_ID"] ?? ""
        public static let secret = ProcessInfo.processInfo.environment["GOOGLE_SECRET"] ?? ""
        public static let callbackUrl = ProcessInfo.processInfo.environment["GOOGLE_CALLBACK_URL"] ?? ""
    }

    public static let sessionSecret = ProcessInfo.processInfo.environment["SESSION_SECRET"] ?? ""
}


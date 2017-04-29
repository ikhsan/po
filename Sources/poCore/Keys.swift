import Foundation

public struct Keys {
    public static let sheetsApiKey = ProcessInfo.processInfo.environment["SHEETS_API_KEY"] ?? ""
    public static let sheetsId = ProcessInfo.processInfo.environment["SHEETS_ID"] ?? ""
    public static let sheetOrder = ProcessInfo.processInfo.environment["SHEET_ORDER_NAME"] ?? ""
    public static let sheetCustomer = ProcessInfo.processInfo.environment["SHEET_CUSTOMER_NAME"] ?? ""
}

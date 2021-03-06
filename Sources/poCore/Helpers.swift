import Foundation
#if os(Linux)
import Dispatch
#endif

// MARK : - Session
extension URLSession {
    public func synchronousDataTask(_ request: URLRequest) throws -> Data {
        var data: Data?
        var error: Error?

        let semaphore = DispatchSemaphore(value: 0)
        let dataTask = self.dataTask(with: request) {
            data = $0
            error = $2
            semaphore.signal()
        }
        dataTask.resume()
        _ = semaphore.wait(timeout: .distantFuture)

        if let error = error { throw error }
        return data ?? Data()
    }
}

// MARK : - Error
public struct PoError: Error {
    let message: String

    public init(_ message: String) {
        self.message = message
    }
}


// MARK : - Hash helper
// Source : https://gist.github.com/kharrison/2355182ac03b481921073c5cf6d77a73
// Source : http://www.cse.yorku.ca/~oz/hash.html
extension String {
    var djb2hash: Int {
        let unicodeScalars = self.unicodeScalars.map { $0.value }
        return unicodeScalars.reduce(5381) {
            ($0 << 5) &+ $0 &+ Int($1)
        }
    }
}

// MARK : - Unique orderer array

extension Sequence where Iterator.Element: Hashable {
    public func unique() -> [Iterator.Element] {
        var seen: [Iterator.Element : Bool] = [:]
        return self.filter { seen.updateValue(true, forKey: $0) == nil }
    }
}

// MARK : - Formatter

public struct PaymentDate {

    private static let formatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "dd/MM/yyyy"
        return f
    }()

    private static let mediumFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "d MMM yyyy"
        return f
    }()

    public static func render(_ date: Date) -> String {
        return formatter.string(from: date)
    }

    public static func renderMediumDate(_ date: Date) -> String {
        return mediumFormatter.string(from: date)
    }

    public static func encode(_ string: String) -> Date {
        return formatter.date(from: string) ?? Date()
    }

}

public struct Rupiah {

    private static let symbol = "Rp "
    private static let formatter: NumberFormatter = {
        let f = NumberFormatter()
        f.numberStyle = .currency
        f.minimumFractionDigits = 0
        f.currencySymbol = symbol
        f.currencyGroupingSeparator = "."
        return f
    }()

    public static func render(_ amount: Double, stripped: Bool = false) -> String {
        let number = NSNumber(value: amount)
        let result = formatter.string(from: number) ?? ""
        return stripped ? result.replacingOccurrences(of: symbol, with: "") : result
    }
    
}

public struct Pound {

    private static let symbol = "£"
    private static let formatter: NumberFormatter = {
        let f = NumberFormatter()
        f.numberStyle = .currency
        f.minimumFractionDigits = 2
        f.maximumFractionDigits = 2
        f.currencySymbol = symbol
        return f
    }()

    public static func render(_ amount: Double, stripped: Bool = false) -> String {
        let number = NSNumber(value: amount)
        let result = formatter.string(from: number) ?? ""
        return stripped ? result.replacingOccurrences(of: symbol, with: "") : result
    }

}

// MARK : - Send via WA

public struct Whatsapp {
    public static func send(_ message: String, phone: String) -> String {
        guard let encoded = message.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return "" }
        return "https://api.whatsapp.com/send?text=\(encoded)&phone=\(phone)"
    }
}

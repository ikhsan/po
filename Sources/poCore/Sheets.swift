import Foundation
import SwiftyJSON

public struct SheetsError: Error {
    let message: String

    public init(_ message: String) {
        self.message = message
    }
}

class SheetsCache {

    private struct TimedJSON {
        let json: JSON
        let timestamp: Date
    }

    private let timeout: TimeInterval
    private var storage: [String : TimedJSON] = [:]

    init(timeout: TimeInterval = 60.0) {
        self.timeout = timeout
    }

    subscript(index: String) -> JSON? {
        get {
            guard let value = storage[index] else { return nil }
            if abs(value.timestamp.timeIntervalSinceNow) > timeout {
                storage.removeValue(forKey: index)
                return nil
            }
            
            return value.json
        }
        set(newJSON) {
            guard let json = newJSON else { storage.removeValue(forKey: index); return; }
            storage[index] = TimedJSON(json: json, timestamp: Date())
        }
    }

}

public struct Sheets {

    private let session = URLSession(configuration: URLSessionConfiguration.default)
    private let baseUrl = URL(string: "https://sheets.googleapis.com/v4/spreadsheets/")!
    private var cache = SheetsCache()

    let apiKey: String

    public init(apiKey: String) {
        self.apiKey = apiKey
    }

    private func makeRequest(_ request: URLRequest) throws -> JSON {
        let data = try session.synchronousDataTask(request)
        return JSON(data: data)
    }

    public func getValue(forSheetId sheetId: String, name: String) throws -> JSON {
        let path = "\(sheetId)/values/\(name)"
        var components = URLComponents(url: baseUrl.appendingPathComponent(path), resolvingAgainstBaseURL: true)
        components?.queryItems = [ URLQueryItem(name: "key", value: apiKey) ]
        guard let url = components?.url else { throw SheetsError("malformed url request") }

        let key = url.absoluteString
        if let cachedValues = cache[key] {
            return cachedValues
        }

        let request = URLRequest(url: url)
        let response = try makeRequest(request)
        let values = response["values"]
        cache[key] = values

        return values
    }

}

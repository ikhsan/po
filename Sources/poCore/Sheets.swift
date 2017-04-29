import Foundation
import SwiftyJSON

public struct SheetsError: Error {
    let message: String

    public init(_ message: String) {
        self.message = message
    }
}

public struct Sheets {

    private let session = URLSession(configuration: URLSessionConfiguration.default)
    private let baseUrl = URL(string: "https://sheets.googleapis.com/v4/spreadsheets/")!

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

        let request = URLRequest(url: url)
        let response = try makeRequest(request)
        return response["values"]
    }

}

import Foundation
import SwiftyJSON

public struct POError : Swift.Error {
    public let message: String

    public init(message: String) {
        self.message = message
    }
}

public enum POEndpoint {
    case customers
    case customer(customerId: String)
    case orders(customerId: String)

    var url: String {
        switch self {
        case .customers:
            return "customers"
        case .customer(let customerId):
            return "customers/\(customerId)"
        case .orders(let customerId):
            return "orders/\(customerId)"
        }
    }
}

public struct POAPI {

    private let baseUrl = "https://po-uk-831d0.firebaseio.com/"
    private let session = URLSession(configuration: URLSessionConfiguration.default)

    public init() {}

    private func buildRequest(_ endpoint: POEndpoint) throws -> URLRequest {
        guard let components = URLComponents(string: baseUrl + endpoint.url + ".json"), let url = components.url else {
            throw POError(message: "Path is not available")
        }
        return URLRequest(url: url)
    }

    private func makeRequest(_ request: URLRequest) throws -> JSON {
        let (optionalData, _, _) = session.synchronousDataTask(with: request)
        guard let data = optionalData else {
            throw POError(message: "Path is not available")
        }
        return JSON(data: data)
    }

    public func get(_ endpoint: POEndpoint) throws -> JSON {
        let request = try buildRequest(endpoint)
        return try makeRequest(request)
    }

    public func post(_ endpoint: POEndpoint, body: JSON) throws -> JSON {
        var request = try buildRequest(endpoint)
        request.httpMethod = "POST"
        request.httpBody = try body.rawData()

        return try makeRequest(request)
    }

    public func delete(_ endpoint: POEndpoint) throws -> JSON {
        var request = try buildRequest(endpoint)
        request.httpMethod = "DELETE"
        return try makeRequest(request)
    }

}


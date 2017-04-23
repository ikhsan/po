import Foundation
import SwiftyJSON

public struct POError : Swift.Error {
    public let message: String
}

public enum POEndpoint {
    case users
    case user(userId: String)
    case orders(userId: String)

    var url: String {
        switch self {
        case .users:
            return "users"
        case .user(let userId):
            return "users/\(userId)"
        case .orders(let userId):
            return "orders/\(userId)"
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

}


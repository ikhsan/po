import Foundation
#if os(Linux)
import Dispatch
#endif

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

public struct PoError: Error {
    let message: String

    public init(_ message: String) {
        self.message = message
    }
}

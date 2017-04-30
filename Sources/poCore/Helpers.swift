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

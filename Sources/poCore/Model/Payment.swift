import Foundation
import SwiftyJSON

public struct Payment {
    public let id: String
    public let date: Date
    public let name: String
    public let deposit: Double

    public init(date: String, name: String, deposit: Double) {
        self.date = PaymentDate.encode(date)
        self.name = name
        self.deposit = deposit

        let hash = "\(name)_\(deposit)_\(date)".djb2hash
        self.id = String(format: "%x", hash)
    }
}

extension Payment: Equatable {}
public func ==(lhs: Payment, rhs: Payment) -> Bool {
    return lhs.id == rhs.id
        && lhs.date == rhs.date
        && lhs.name == rhs.name
        && lhs.deposit == rhs.deposit
}

extension Payment: Hashable {
    public var hashValue: Int {
        return self.id.djb2hash
    }
}

extension Payment {
    public static func parse(json: JSON) throws -> Payment {
        let parsingError = PoError("Parsing Order errored")
        guard let array = json.array else { throw parsingError }

        guard array.count > 0,
            let date = array[0].string
            else { throw parsingError }

        guard array.count > 1,
            let name = array[1].string
            else { throw parsingError }

        guard array.count > 2,
            let depositString = array[2].string
            else { throw parsingError }

        return Payment(
            date: date,
            name: name,
            deposit: Double(depositString) ?? 0
        )
    }    
}

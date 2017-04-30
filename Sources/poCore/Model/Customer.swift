import Foundation
import SwiftyJSON

public struct Customer {
    public let id: String
    public let name: String
    public let phone: String

    public init(name: String, phone: String) {
        self.name = name
        self.phone = phone
        self.id = String(format: "%x", "\(name) + \(phone)".djb2hash)
    }
}

extension Customer: Equatable {}
public func ==(lhs: Customer, rhs: Customer) -> Bool {
    return lhs.name == rhs.name && lhs.phone == rhs.phone
}

extension Customer: Hashable {
    public var hashValue: Int {
        return self.id.djb2hash
    }
}

extension Customer {
    public static func parse(json: JSON) throws -> Customer {
        let parsingError = PoError("Parsing Order errored")
        guard let array = json.array else { throw parsingError }

        guard array.count > 0,
            let name = array[0].string
            else { throw parsingError }

        guard array.count > 1,
            let phone = array[1].string,
            (phone.rangeOfCharacter(from: CharacterSet.decimalDigits) != nil)
            else { throw parsingError }

        return Customer(name: name, phone: phone)
    }    
}

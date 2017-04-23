import XCTest
import SwiftyJSON
@testable import poCore

class CustomerTests: XCTestCase {

    let customerFixtureData = "{\"-KiCn22_ANil9wZF6Cqz\":{\"name\":\"Ikhsan Assaat\",\"phone\":\"087654321000\"}}"

    func testParse_WithInvalidJSON_ShouldReturnNil() {
        let json = JSON(data: "<invalid>".data(using: .utf8)!)
        let customer = Customer.parse(json: json)
        XCTAssertNil(customer)
    }

    func testParse_WithValidJSON_ShouldReturnValidUser() {
        let json = JSON.parse(string: customerFixtureData)
        let customer = Customer.parse(json: json)!

        let expectedCustomer = Customer(id: "-KiCn22_ANil9wZF6Cqz", name: "Ikhsan Assaat", phone: "087654321000")
        XCTAssertEqual(customer, expectedCustomer)
    }

}

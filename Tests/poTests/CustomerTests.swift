import XCTest
import SwiftyJSON
@testable import poCore

class CustomerTests: XCTestCase {

    func testParse_WithInvalidJSON_ShouldThrow() {
        let json = JSON(data: "<invalid>".data(using: .utf8)!)
        XCTAssertThrowsError(_ = try Customer.parse(json: json))
    }

    func testParse_WithHeadersJSON_ShouldThrow() {
        let json = JSON(["Customer", "Phone Number"])
        XCTAssertThrowsError(_ = try Customer.parse(json: json))
    }

    func testParse_WithValidJSON_ShouldReturnValidUser() throws {
        let customer = try Customer.parse(json: JSON(["Mbak dyta", "+628170003511"]))
        let expectedCustomer = Customer(name: "Mbak dyta", phone: "+628170003511")
        XCTAssertEqual(customer, expectedCustomer)
    }

}

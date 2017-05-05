import XCTest
import SwiftyJSON
import poCore

class PatmentTests: XCTestCase {

    func testParse_WithInvalidJSON_ShouldThrow() throws {
        let json = JSON(data: "<invalid>".data(using: .utf8)!)
        XCTAssertThrowsError(_ = try Order.parse(json: json))
    }

    func testParse_WithValidJSON_ShouldReturnValidUser() throws {
        let payment = try Payment.parse(json: JSON([
            "27/04/2017",
            "Miranda",
            "400000"
        ]))

        let expectedPayment = Payment(date: "27/04/2017", name: "Miranda", deposit: 400_000)
        XCTAssertEqual(payment, expectedPayment)
    }

}

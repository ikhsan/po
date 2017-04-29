import XCTest
import SwiftyJSON
@testable import poCore

class OrderTests: XCTestCase {

    func testParse_WithInvalidJSON_ShouldReturnNil() throws {
        let json = JSON(data: "<invalid>".data(using: .utf8)!)
        XCTAssertThrowsError(_ = try Order.parse(json: json))
    }

    func testParse_WithValidJSON_ShouldReturnValidUser() throws {
        let order = try Order.parse(json: JSON([
            "Indi_exp",
            "Speedo blue",
            "3",
            "9.5",
            "28.5",
            "210,000",
            "630,000",
            "159,750",
            "✅",
            "✅"
        ]))
        let expectedOrder = Order(customer: "Indi_exp", productName: "Speedo blue", buyPrice: 9.5, sellPrice: 210_000, quantity: 3, status: .delivered)
        XCTAssertEqual(order, expectedOrder)
    }

    func testParse_WithoutStatus_SHouldReturnValidUser() throws {
        let order = try Order.parse(json: JSON([
            "Sila",
            "Salicylic Acid 2",
            "5",
            "6.95",
            "34.75",
            "255,000",
            "1,275,000",
            "701,625"
        ]))
        let expectedOrder = Order(customer: "Sila", productName: "Salicylic Acid 2", buyPrice: 6.95, sellPrice: 255_000, quantity: 5, status: .pending)
        XCTAssertEqual(order, expectedOrder)
    }
}

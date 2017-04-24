import XCTest
import SwiftyJSON
@testable import poCore

class OrderTests: XCTestCase {

    func testParse_WithInvalidJSON_ShouldReturnNil() {
        let json = JSON(data: "<invalid>".data(using: .utf8)!)
        let order = Order.parse(json: json)
        XCTAssertNil(order)
    }

    let orderFixtureData = "{\"id123\":{\"productName\":\"Speedo Blue\",\"buyPrice\":20,\"sellPrice\":450000,\"quantity\":2,\"isOrdered\":false,\"isDelivered\":true}}"
    func testParse_WithValidJSON_ShouldReturnValidUser() {
        let json = JSON.parse(string: orderFixtureData)
        let order = Order.parse(json: json)!

        let expectedOrder = Order(
            id: "id123",
            productName: "Speedo Blue",
            buyPrice: 20.0,
            sellPrice: 450_000,
            quantity: 2,
            isOrdered: false,
            isDelivered: true
        )
        XCTAssertEqual(order, expectedOrder)
    }
    
}

import XCTest
import SwiftyJSON
@testable import poCore

class UserTests: XCTestCase {

    let userFixtureData = "{\"-KiCn22_ANil9wZF6Cqz\":{\"email\":\"ikhsan1@test.com\",\"name\":\"Ikhsan Assaat\",\"phone\":\"087654321000\"}}"

    func testParse_WithInvalidJSON_ShouldReturnNil() {
        let json = JSON(data: "<invalid>".data(using: .utf8)!)
        let user = User.parse(json: json)

        XCTAssertNil(user)
    }

    func testParse_WithValidJSON_ShouldReturnValidUser() {
        let json = JSON.parse(string: userFixtureData)
        let user = User.parse(json: json)!

        let expectedUser = User(id: "-KiCn22_ANil9wZF6Cqz", name: "Ikhsan Assaat", phone: "087654321000", email: "ikhsan1@test.com")
        XCTAssertEqual(expectedUser, user)
    }

    func testEncodeToJson() {
        let json = JSON.parse(string: userFixtureData)
        let user = User.parse(json: json)!

        let expectedJson = JSON([
            "id": JSON(stringLiteral: "-KiCn22_ANil9wZF6Cqz"),
            "name": JSON(stringLiteral: "Ikhsan Assaat"),
            "phone": JSON(stringLiteral: "087654321000"),
            "email": JSON(stringLiteral: "ikhsan1@test.com"),
        ])
        XCTAssertEqual(expectedJson, user.json)
    }

}

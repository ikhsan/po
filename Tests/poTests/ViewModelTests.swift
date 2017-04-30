import XCTest
import poCore

class OrderViewModelTests: XCTestCase {

    var order: Order!
    var customer: Customer!

    override func setUp() {
        customer = Customer(name: "John Doe", phone: "+44 87654321000")
        order = Order(customer: "John Doe", productName: "iPhone 10", buyPrice: 50, sellPrice: 1_000_000)
    }

    // MARK: - Status

    func test_PendingOrder_ShouldGetCorrectStatus() {
        let subject = OrderViewModel(order, customer: customer)
        XCTAssertEqual(subject.status, "❓")
    }

    func test_Ordered_ShouldGetCorrectStatus() {
        order.status = .ordered
        let subject = OrderViewModel(order, customer: customer)
        XCTAssertEqual(subject.status, "💳")
    }

    func test_DeliveredOrder_ShouldGetCorrectStatus() {
        order.status = .delivered
        let subject = OrderViewModel(order, customer: customer)
        XCTAssertEqual(subject.status, "📦")
    }

    // MARK: - Product name

    func testProductName() {
        let subject = OrderViewModel(order, customer: customer)
        XCTAssertEqual(subject.productName, "iPhone 10")
    }

    // MARK: - Price name

    func testProductPrice() {
        let subject = OrderViewModel(order, customer: customer)
        XCTAssertEqual(subject.productPrice, "Rp 1.000.000")
    }

    func testProductTotalPrice() {
        order.quantity = 10
        let subject = OrderViewModel(order, customer: customer)
        XCTAssertEqual(subject.totalPrice, "10.000.000")
    }

    // MARK: - Customer

    func testCustomer() {
        let subject = OrderViewModel(order, customer: customer)
        XCTAssert(!subject.customerName.isEmpty)
        XCTAssertEqual(subject.customerName, "John Doe")
    }

}

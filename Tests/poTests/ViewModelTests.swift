import XCTest
import poCore

class PaymentViewModelTests: XCTestCase {

    var payment: Payment!
    var customer: Customer!

    override func setUp() {
        super.setUp()

        customer = Customer(name: "John Doe", phone: "+44 87654321000")
        payment = Payment(date: "04/05/2017", name: "John Doe", deposit: 500_000)
    }

    func testDate() {
        let subject = PaymentViewModel(payment, customer: customer)
        XCTAssertEqual(subject.date, "4 May 2017")
    }

    func testDeposit() {
        let subject = PaymentViewModel(payment, customer: customer)
        XCTAssertEqual(subject.deposit, "500.000")
    }

}

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

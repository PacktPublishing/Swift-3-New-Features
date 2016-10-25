import XCTest
@testable import Product

class ProductTests: XCTestCase {
	func testInitSetsParams(){
		let product = Product(id: 1, name: "Test Product", price: 100.00)
		
		XCAssertEqual(product.price, 100.00, "Incorrect price")
	}
}

#if os(Linux)
extension ProductTests {
	static var allTests : [(String, ProductTests -> () throws -> Void)] {
		return [
			("testInitSetsParams")
  		]
	}
}
#endif

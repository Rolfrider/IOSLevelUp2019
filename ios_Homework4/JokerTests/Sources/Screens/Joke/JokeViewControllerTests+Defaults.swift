import XCTest
import UIKit
@testable import Joker

class JokeViewControllerTests_Defaults: XCTestCase {

	var sut: JokeViewController!

	override func setUp() {
		super.setUp()
		sut = JokeViewController()
	}

	override func tearDown() {
		sut = nil
	}

	func testDefaultJokeProviderShouldBeNetwork() {
		XCTAssertTrue(sut.jokeProvider is JokeNetworkProvider)
	}
}

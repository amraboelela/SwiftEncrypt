import XCTest
@testable import SwiftEncrypt

final class StringTests: TestsBase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testHashBase16() {
        let url = "http://massive.net"
        XCTAssertEqual(url.hashBase16(numberOfDigits: 32), "0e2f3028ac5eeea06c8b26c7c67a3071")
    }
    
}
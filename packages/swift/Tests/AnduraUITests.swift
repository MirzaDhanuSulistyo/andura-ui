import XCTest
@testable import AnduraUI

final class AnduraUITests: XCTestCase {
    func testCompleteDesignSystemCatalog() {
        XCTAssertEqual(AnduraDesignSystems.all.count, 151)
        XCTAssertEqual(AnduraDesignSystems.byID("linear-app").name, "Linear")
        XCTAssertEqual(AnduraDesignSystems.byID("missing").id, "default")
    }
}

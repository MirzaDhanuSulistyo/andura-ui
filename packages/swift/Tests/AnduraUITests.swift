import XCTest
import AnduraUI

final class AnduraUITests: XCTestCase {
    func testCompleteDesignSystemCatalog() {
        XCTAssertEqual(AnduraDesignSystems.all.count, 151)
        XCTAssertEqual(AnduraDesignSystems.byID("linear-app").name, "Linear")
        XCTAssertEqual(AnduraDesignSystems.byID("missing").id, "default")
    }

    func testAppLocalDesignSystemDoesNotRequireCatalogRegistration() {
        let custom = AnduraDesignSystems.defaultSystem.copyWith(
            id: "acme",
            name: "Acme",
            accent: 0xFF6750A4
        )

        XCTAssertEqual(custom.id, "acme")
        XCTAssertEqual(custom.accent, 0xFF6750A4)
        XCTAssertFalse(AnduraDesignSystems.all.contains(custom))
    }
}

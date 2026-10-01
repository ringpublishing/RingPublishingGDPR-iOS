import XCTest
@testable import RingPublishingGDPR

final class TenantConfigurationTests: XCTestCase {

    private func makeConfiguration(_ url: String) throws -> TenantConfiguration {
        try XCTUnwrap(TenantConfiguration(urlString: url, gdprApplies: true))
    }

    func testUrlIsUnchangedWithoutAdditionalParameters() throws {
        let config = try makeConfiguration("https://cmp.example.com/form")

        XCTAssertEqual(config.cmpUrl(appending: [:]).absoluteString, "https://cmp.example.com/form")
    }

    func testParametersAreAppendedToUrlWithoutQuery() throws {
        let config = try makeConfiguration("https://cmp.example.com/form")

        XCTAssertEqual(config.cmpUrl(appending: ["app_is": "abc"]).absoluteString, "https://cmp.example.com/form?app_is=abc")
    }

    func testExistingQueryParametersArePreserved() throws {
        let config = try makeConfiguration("https://cmp.example.com/form?site=onet")

        XCTAssertEqual(config.cmpUrl(appending: ["app_is": "abc"]).absoluteString, "https://cmp.example.com/form?site=onet&app_is=abc")
    }

    func testSameNamedParameterReplacesExistingOne() throws {
        let config = try makeConfiguration("https://cmp.example.com/form?app_is=old&site=onet")

        XCTAssertEqual(config.cmpUrl(appending: ["app_is": "new"]).absoluteString, "https://cmp.example.com/form?site=onet&app_is=new")
    }

    func testValuesAreEncodedOnceAndExistingEncodingIsNotDoubled() throws {
        let config = try makeConfiguration("https://cmp.example.com/form?q=a%20b")
        let url = config.cmpUrl(appending: ["app_is": "a b&c=d"])
        let components = try XCTUnwrap(URLComponents(url: url, resolvingAgainstBaseURL: false))

        XCTAssertEqual(components.queryItems?.first(where: { $0.name == "q" })?.value, "a b")
        XCTAssertEqual(components.queryItems?.first(where: { $0.name == "app_is" })?.value, "a b&c=d")
        XCTAssertFalse(url.absoluteString.contains("%25"))
    }
}

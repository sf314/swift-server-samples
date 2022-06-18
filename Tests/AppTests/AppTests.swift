@testable import App
import XCTVapor

final class AppTests: XCTestCase {
    func testHelloWorld() throws {
        // Boilerplate setup
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)

        // Verify simple GET
        try app.test(.GET, "hello", afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            XCTAssertEqual(res.body.string, "Hello, world!")
        })
    }

    func testSinglePathParam() throws {
        // Boilerplate setup
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)

        // Verify that single path param can be extracted
        try app.test(.GET, "tests/pathparams/foo", afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            XCTAssertEqual(res.body.string, "Single path param: foo")
        })

        // Failure to specify a path param results in default value
        try app.test(.GET, "tests/pathparams", afterResponse: { res in
            XCTAssertEqual(res.status, .notFound)
        })
    }
}

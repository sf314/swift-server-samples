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

    func testMultiplePathParams() throws {
        // Boilerplate setup
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)

        // Verify that multiple path params can be accepted
        try app.test(.GET, "tests/residents/steve/pets/barky", afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            XCTAssertEqual(res.body.string, "steve's pet is barky!")
        })

        // First path param is required. Otherwise, 404
        try app.test(.GET, "tests/residents//pets/barky", afterResponse: { res in
            XCTAssertEqual(res.status, .notFound)
        })

        // Second path param is also required. Otherwise, 404
        try app.test(.GET, "tests/residents/steve/pets/", afterResponse: { res in
            XCTAssertEqual(res.status, .notFound)
        })
    }

    func testStringQueryParams() throws {
        // Boilerplate setup
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)

        // Two strings can be pulled from endpoint
        try app.test(.GET, "/tests/queries/strings?name=Geoff&city=Paris", afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            XCTAssertEqual(res.body.string, "Query params: name=Geoff, city=Paris")
        })
    }
}

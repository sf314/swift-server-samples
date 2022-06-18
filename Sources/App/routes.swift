import Vapor

func routes(_ app: Application) throws {
    app.get { req in
        return "It works!"
    }

    app.get("hello") { req -> String in
        return "Hello, world!"
    }

    // Read single path param
    app.get("tests", "pathparams", ":someValue") { req -> String in 
        let someValue = req.parameters.get("someValue") // Optional!
        return "Single path param: \(someValue ?? "unknown")" // Since it can be optional, we should supply a default
    }
}

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

    // Read multiple path params
    app.get("tests", "residents", ":name", "pets", ":petName") { req -> Response in
        // Is a given key always guaranteed to exist? The app 404's when a path param is not present
        guard let name = req.parameters.get("name") else {
            return Response.init(status: .badRequest, body: "Resident name must be supplied!")
        }

        guard let pet = req.parameters.get("petName") else {
            print(name)
            return Response.init(status: .badRequest, body: "Pet name must be supplied!")
        }

        return Response.init(status: HTTPResponseStatus.ok, body: Response.Body.init(string: "\(name)'s pet is \(pet)!"))
    }

    app.group("tests", "queries") { queryGroup in
        queryGroup.get("strings") { req -> Response in
            // Note: type information cannot always be inferred, and it's not necessarily a string either!
            // Note: dictionary lookups return optionals!
            let name: String = req.query["name"] ?? "no-name"
            let city: String = req.query["city"] ?? "no-city"

            return Response.init(status: .ok, body: Response.Body.init(string: "Query params: name=\(name), city=\(city)"))
        }
    }
}

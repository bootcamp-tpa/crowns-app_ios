import Foundation

struct Request {
    static func createUser(username: String) -> URLRequest {
        return request(
            path: "/user/create",
            method: .post,
            body: ["name": username].toBodyData
        )
    }
    
    static func createGame() -> URLRequest {
        return request(
            path: "/game/new",
            method: .get
        )
    }
    
    static func submitHighscore(_ highscore: Highscore) -> URLRequest {
        return request(
            path: "highscores/submit",
            method: .post,
            body: highscore.toBodyData
        )
    }
    
    static func getHighscores() -> URLRequest {
        return request(
            path: "highscores",
            method: .get
        )
    }
    
    private static func request(
        path: String,
        method: Method,
        body: Data? = nil
    ) -> URLRequest {
        let baseURL = URL(string: "http://0.0.0.0:8081")!
        let urlWithPath = baseURL.appendingPathComponent(path)
        var urlRequest = URLRequest(url: urlWithPath)
        if let body = body {
            urlRequest.httpBody = body
        }
        urlRequest.httpMethod = method.rawValue
        return urlRequest
    }
}

private enum Method: String {
    case get = "GET"
    case post = "POST"
}

private extension Encodable {
    var toBodyData: Data? {
        let encoder = JSONEncoder.toSnakeCaseEncoder
        return try? encoder.encode(self)
    }
}

private extension Dictionary where Key == String {
    var toBodyData: Data? {
        return try? JSONSerialization.data(withJSONObject: self, options: [])
    }
}

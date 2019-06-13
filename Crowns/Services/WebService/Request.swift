import Foundation

struct Request {
    static func createUser(username: String) -> URLRequest {
        return request(path: "/user/create", method: .post, params: ["name": username])
    }
    
    static func createGame() -> URLRequest {
        return request(path: "/game/get", method: .get)
    }
    
    private static func request(
        path: String,
        method: Method,
        params: [String: Any]? = nil
    ) -> URLRequest {
        let baseURL = URL(string: "http://0.0.0.0:8081")!
        let urlWithPath = baseURL.appendingPathComponent(path)
        var urlRequest = URLRequest(url: urlWithPath)
        if let params = params, let data = try? JSONSerialization.data(withJSONObject: params, options: []) {
            urlRequest.httpBody = data
        }
        urlRequest.httpMethod = method.rawValue
        return urlRequest
    }
}

private enum Method: String {
    case get = "GET"
    case post = "POST"
}

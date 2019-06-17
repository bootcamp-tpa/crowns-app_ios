import Foundation
import SwiftJWT

protocol WebService {
    func createUser(
        withUsername username: String,
        completion: @escaping (Result<User, ApiError>) -> Void
    )
    func createGame(completion: @escaping (Result<Deck, ApiError>) -> Void)
    func submitHighscore(
        _ highscore: Highscore,
        completion: @escaping (Result<Void, ApiError>) -> Void
    )
    func getHighscores(completion: @escaping (Result<Highscores, ApiError>) -> Void)
}

final class WebServiceImp: WebService {
    private lazy var session = URLSession(configuration: .default)
    private static let decoder = JSONDecoder.fromSnakeCaseDecoder
    private let requestAuthorizer: RequestAuthorizer
    
    init(storage: JSONStorage = JSONStorageImp()) {
        self.requestAuthorizer = RequestAuthorizer(storage: storage)
    }
    
    func createUser(
        withUsername username: String,
        completion: @escaping (Result<User, ApiError>) -> Void
    ) {
        request(
            urlRequest: Request.createUser(username: username),
            completion: completion
        )
    }

    func createGame(completion: @escaping (Result<Deck, ApiError>) -> Void) {
        authorizedRequest(
            urlRequest: Request.createGame(),
            completion: completion
        )
    }
    
    func submitHighscore(
        _ highscore: Highscore,
        completion: @escaping (Result<Void, ApiError>) -> Void
    ) {
        let comp: (Result<String, ApiError>) -> Void = { completion($0.map { _ in () }) }
        authorizedRequest(
            urlRequest: Request.submitHighscore(highscore),
            completion: comp
        )
    }
    
    func getHighscores(completion: @escaping (Result<Highscores, ApiError>) -> Void) {
        authorizedRequest(
            urlRequest: Request.getHighscores(),
            completion: completion
        )
    }
    
    private func authorizedRequest<T: Decodable>(
        urlRequest: URLRequest,
        completion: @escaping (Result<T, ApiError>) -> Void
    ) {
        let authorizationOutcome = requestAuthorizer.authorize(urlRequest)
        switch authorizationOutcome {
        case .success(let authorizedURLRequest):
            request(urlRequest: authorizedURLRequest, completion: completion)
        case .failure(let error):
            completion(.failure(error))
        }
        
    }
    
    private func request<T: Decodable>(
        urlRequest: URLRequest,
        completion: @escaping (Result<T, ApiError>) -> Void
    ) {
        print(urlRequest.curlString)
        session.dataTask(
            with: urlRequest,
            completionHandler: { (data, response, error) in
                func sendAPIError() {
                    DispatchQueue.main.async {
                        if let data = data,
                            let apiError = try? WebServiceImp.decoder.decode(ApiError.self, from: data) {
                            completion(.failure(apiError))
                        } else {
                            completion(.failure(ApiError.unknown))
                        }
                    }
                }
                
                guard let response = response as? HTTPURLResponse else {
                    sendAPIError()
                    return
                }
                
                switch response.statusCode {
                case 200...299:
                    guard let data = data else {
                        sendAPIError()
                        return
                    }
                    do {
                        let result = try WebServiceImp.decoder.decode(T.self, from: data)
                        DispatchQueue.main.async {
                            completion(.success(result))
                        }
                    } catch {
                        sendAPIError()
                    }
                default:
                    sendAPIError()
                }
        }
            ).resume()
    }
}

extension URLRequest {
    public var curlString: String {
        let request = self
        guard
            let url = request.url,
            let method = request.httpMethod else { return "$ curl command could not be created" }
        
        var components = ["$ curl -v"]
        
        components.append("-X \(method)")
        
        var headers: [String: String] = [:]
        
        if let headerFields = request.allHTTPHeaderFields {
            for (field, value) in headerFields where field != "Cookie" {
                headers[field] = value
            }
        }
        
        for (field, value) in headers {
            let escapedValue = value.replacingOccurrences(of: "\"", with: "\\\"")
            components.append("-H \"\(field): \(escapedValue)\"")
        }
        
        if let httpBodyData = request.httpBody, let httpBody = String(data: httpBodyData, encoding: .utf8) {
            var escapedBody = httpBody.replacingOccurrences(of: "\\\"", with: "\\\\\"")
            escapedBody = escapedBody.replacingOccurrences(of: "\"", with: "\\\"")
            
            components.append("-d \"\(escapedBody)\"")
        }
        
        components.append("\"\(url.absoluteString)\"")
        
        return components.joined(separator: " \\\n\t")
    }
}

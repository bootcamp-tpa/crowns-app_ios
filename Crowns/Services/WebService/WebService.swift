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
    func getHighscores(completion: @escaping (Result<[Highscore], ApiError>) -> Void)
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
            authorized: false,
            completion: completion
        )
    }

    func createGame(completion: @escaping (Result<Deck, ApiError>) -> Void) {
        request(
            urlRequest: Request.createGame(),
            authorized: true,
            completion: completion
        )
    }
    
    func submitHighscore(
        _ highscore: Highscore,
        completion: @escaping (Result<Void, ApiError>) -> Void
    ) {
        let mappedCompletion: (Result<Data, ApiError>) -> Void = { completion($0.map { _ in () }) }
        let submitHighscore = SubmitHighscore(highscore: highscore)
        requestData(
            urlRequest: Request.submitHighscore(submitHighscore),
            authorized: true,
            completion: mappedCompletion
        )
    }
    
    func getHighscores(completion: @escaping (Result<[Highscore], ApiError>) -> Void) {
        let mappedCompletion: (Result<Highscores, ApiError>) -> Void = { completion($0.map { $0.highscores }) }
        request(
            urlRequest: Request.getHighscores(),
            authorized: true,
            completion: mappedCompletion
        )
    }
    
    private func request<T: Decodable>(
        urlRequest: URLRequest,
        authorized: Bool,
        completion: @escaping (Result<T, ApiError>) -> Void
    ) {
        requestData(
            urlRequest: urlRequest,
            authorized: authorized,
            completion: { result in
                let decodedResult = result.flatMap { data -> Result<T, ApiError> in
                    do {
                        let decoded = try WebServiceImp.decoder.decode(T.self, from: data)
                        return .success(decoded)
                    } catch {
                        return .failure(.unknown)
                    }
                }
                completion(decodedResult)
        })
    }
    
    private func requestData(
        urlRequest: URLRequest,
        authorized: Bool,
        completion: @escaping (Result<Data, ApiError>) -> Void
    ) {
        if authorized {
            let authorizationOutcome = requestAuthorizer.authorize(urlRequest)
            switch authorizationOutcome {
            case .success(let authorizedURLRequest):
                requestData(
                    urlRequest: authorizedURLRequest,
                    completion: completion
                )
            case .failure(let error):
                completion(.failure(error))
            }
        } else {
            requestData(
                urlRequest: urlRequest,
                completion: completion
            )
        }
    }
    
    private func requestData(
        urlRequest: URLRequest,
        completion: @escaping (Result<Data, ApiError>) -> Void
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
                    DispatchQueue.main.async {
                        completion(.success(data))
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

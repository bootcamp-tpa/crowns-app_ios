import Foundation

protocol WebService {
    func createUser(
        withUsername username: String,
        completion: @escaping (Result<User, ApiError>) -> Void
    )
    func createGame(completion: @escaping (Result<Deck, ApiError>) -> Void)
}

final class WebServiceImp: WebService {
    private lazy var session = URLSession(configuration: .default)
    private static let decoder = JSONDecoder()
    
    func createUser(
        withUsername username: String,
        completion: @escaping (Result<User, ApiError>) -> Void
    ) {
        request(
            request: Request.createUser(username: username),
            completion: completion
        )
    }
    
    func createGame(completion: @escaping (Result<Deck, ApiError>) -> Void) {
        // TODO: call api once token handling is ready
        let leftChoice = CardChoice(nextCard: nil, choiceText: "Left", churchModifier: 15, commonersModifier: 12, merchantsModifier: 10, militaryModifier: -10, bonusModifier: 2)
        let rightChoice = CardChoice(nextCard: nil, choiceText: "Right", churchModifier: 12, commonersModifier: -10, merchantsModifier: 10, militaryModifier: 10, bonusModifier: 10)
        let card = Card(id: 0, cardText: "CARD1", cardType: .event, cardImage: .church, leftChoice: leftChoice, rightChoice: rightChoice)
        let deck = Deck(cards: Array(repeating: card, count: 1))
        completion(.success(deck))
    }
    
    private func request<T: Decodable>(
        request: URLRequest,
        completion: @escaping (Result<T, ApiError>) -> Void
        ) {
        print(request.curlString)
        session.dataTask(
            with: request,
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

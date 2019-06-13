import SwiftJWT

struct RequestAuthorizer {
    private let storage: JSONStorage
    
    init(storage: JSONStorage) {
        self.storage = storage
    }
    
    func authorize(_ request: URLRequest) -> Result<URLRequest, ApiError> {
        guard let user = storage.getUser(),
              let signedJWT = createSignedJWT(forUser: user) else {
                return .failure(.unknown)
        }
        var request = request
        request.setValue(signedJWT, forHTTPHeaderField: "Token")
        return .success(request)
    }
    
    private func createSignedJWT(forUser user: User) -> String? {
        let expiresAt = Date(timeIntervalSinceNow: 60 * 60 * 24 * 30)
        let claims = CrownsClaims(name: user.name, expiration: expiresAt)
        var jwt = JWT(claims: claims)
        guard let key = user.token.data(using: .utf8) else { return nil }
        return try? jwt.sign(using: .hs256(key: key))
    }
}

private struct CrownsClaims: Claims {
    let name: String
    let expiration: Date
}

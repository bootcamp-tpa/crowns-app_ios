import SwiftJWT

struct RequestAuthorizer {
    private let storage: JSONStorage
    
    init(storage: JSONStorage) {
        self.storage = storage
    }
    
    func authorize(_ request: URLRequest) -> URLRequest? {
        guard let user = storage.getUser() else { return nil }
        var request = request
        let signedJWT = createSignedJWT(forUser: user)
        request.setValue(signedJWT, forHTTPHeaderField: "Token")
        return request
    }
    
    private func createSignedJWT(forUser user: User) -> String {
        let expiresAt = Date(timeIntervalSinceNow: 60 * 60 * 24 * 30)
        let claims = CrownsClaims(name: user.name, expiration: expiresAt)
        var jwt = JWT(claims: claims)
        let key = user.token.data(using: .utf8)!
        return try! jwt.sign(using: .hs256(key: key))
    }
}

private struct CrownsClaims: Claims {
    let name: String
    let expiration: Date
}

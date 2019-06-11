struct ApiError: Error {
    let title: String
}

extension ApiError: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let title = try container.decode(String.self)
        if title == "user already exists" {
            self.title = "Username has already been taken."
        } else {
            throw ApiError.unknown
        }
    }
}

extension ApiError {
    static var unknown: ApiError {
        return ApiError(title: "Something went wrong.")
    }
}

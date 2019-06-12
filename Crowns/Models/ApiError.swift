struct ApiError: Error {
    let title: String
}

extension ApiError: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.title = try container.decode(String.self)
    }
}

extension ApiError {
    static var unknown: ApiError {
        return ApiError(title: "Something went wrong.")
    }
}

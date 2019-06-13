import Foundation

protocol JSONStorage {
    func store(user: User)
    func getUser() -> User?
}

struct JSONStorageImp: JSONStorage {
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    private let baseURL: URL
    
    public init(
        searchPath: FileManager.SearchPathDirectory = .documentDirectory,
        fileManager: FileManager = .default
    ) {
        self.baseURL = fileManager.urls(for: searchPath, in: .userDomainMask).first!
    }
    
    func store(user: User) {
        write(user, toPath: StoragePath.user)
    }
    
    func getUser() -> User? {
        return read(atPath: StoragePath.user)
    }
    
    private func write<T: Encodable>(_ model: T, toPath path: String) {
        let fileURL = baseURL.appendingPathComponent(path)
        let data = try! encoder.encode(model)
        try? data.write(to: fileURL)
    }
    
    private func read<T: Decodable>(atPath path: String) -> T? {
        let fileURL = baseURL.appendingPathComponent(path)
        let data1 = try? Data(contentsOf: fileURL)
        guard let data = data1,
              let model = try? decoder.decode(T.self, from: data) else { return nil }
        return model
    }
}

private struct StoragePath {
    static var user: String { return "HT.Crowns.user" }
}

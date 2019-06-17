import Foundation

protocol JSONStorage {
    func store(user: User)
    func getUser() -> User?
    func store(game: Game?)
    func getGame() -> Game?
}

struct JSONStorageImp: JSONStorage {
    private let encoder = JSONEncoder.toSnakeCaseEncoder
    private let decoder = JSONDecoder.fromSnakeCaseDecoder
    private let baseURL: URL
    private let fileManager: FileManager
    
    init(
        searchPath: FileManager.SearchPathDirectory = .documentDirectory,
        fileManager: FileManager = .default
    ) {
        self.baseURL = fileManager.urls(for: searchPath, in: .userDomainMask).first!
        self.fileManager = fileManager
    }
    
    func store(user: User) {
        write(user, toPath: .user)
    }
    
    func getUser() -> User? {
        return read(atPath: .user)
    }
    
    func store(game: Game?) {
        if let game = game {
            write(game, toPath: .game)
        } else {
            remove(atPath: .game)
        }
    }
    
    func getGame() -> Game? {
        return read(atPath: .game)
    }
    
    private func write<T: Encodable>(_ model: T, toPath path: StoragePath) {
        let fileURL = baseURL.appendingPathComponent(path.rawValue)
        let data = try! encoder.encode(model)
        try? data.write(to: fileURL)
    }
    
    private func read<T: Decodable>(atPath path: StoragePath) -> T? {
        let fileURL = baseURL.appendingPathComponent(path.rawValue)
        let data1 = try? Data(contentsOf: fileURL)
        guard let data = data1,
              let model = try? decoder.decode(T.self, from: data) else { return nil }
        return model
    }
    
    private func remove(atPath path: StoragePath) {
        let fileURL = baseURL.appendingPathComponent(path.rawValue)
        try? fileManager.removeItem(at: fileURL)
    }
}

private enum StoragePath: String {
    case user = "HT.Crowns.user"
    case game = "HT.Crowns.game"
}

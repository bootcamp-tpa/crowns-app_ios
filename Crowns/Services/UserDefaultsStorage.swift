import Foundation

protocol UserDefaultsStorage {
    func store(user: User)
    func getUser() -> User?
}

struct UserDefaultsStorageImp: UserDefaultsStorage {
    private let defaults = UserDefaults.standard
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    func store(user: User) {
        write(user, forKey: DefaultsKeys.user)
    }
    
    func getUser() -> User? {
        return read(atKey: DefaultsKeys.user)
    }
    
    private func write<T: Encodable>(_ model: T, forKey key: String) {
        let data = try! encoder.encode(model)
        defaults.set(data, forKey: key)
    }
    
    private func read<T: Decodable>(atKey key: String) -> T? {
        guard let data = defaults.data(forKey: key),
              let model = try? decoder.decode(T.self, from: data) else { return nil }
        return model
    }
}

private struct DefaultsKeys {
    static var user: String { return "user_defaults_storage.user" }
}

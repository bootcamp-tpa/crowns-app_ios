struct Dependencies {
    static let instance = Dependencies()
    
    let webService: WebService
    let userDefaultsStorage: UserDefaultsStorage
    
    private init() {
        self.webService = WebServiceImp()
        self.userDefaultsStorage = UserDefaultsStorageImp()
    }
}

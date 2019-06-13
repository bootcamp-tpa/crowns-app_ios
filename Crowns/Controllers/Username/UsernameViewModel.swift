protocol UsernameViewModelDelegate: AnyObject {
    func showLoadingIndicator(_ show: Bool)
    func enableStartButton(_ enable: Bool)
    func showErrorAlert(withMessage message: String)
    func showGameController(forUser user: User)
}

class UsernameViewModel {
    weak var delegate: UsernameViewModelDelegate!
    private let storage: JSONStorage
    private let webService: WebService
    private var username: String?
    
    init(storage: JSONStorage,
         webService: WebService) {
        self.storage = storage
        self.webService = webService
    }
    
    func textFieldValueDidChange(to value: String?) {
        username = value
        if let value = value, !value.isEmpty {
            delegate.enableStartButton(true)
        } else {
            delegate.enableStartButton(false)
        }
    }
    
    func didTapStartButton() {
        guard let username = username, !username.isEmpty else { return }
        attemptToCreateUser(withUsername: username)
    }
    
    private func attemptToCreateUser(withUsername username: String) {
        delegate.showLoadingIndicator(true)
        webService.createUser(
            withUsername: username,
            completion: { [delegate, storage] result in
                delegate?.showLoadingIndicator(false)
                switch result {
                case .success(let user):
                    storage.store(user: user)
                    delegate?.showGameController(forUser: user)
                case .failure(let error):
                    delegate?.showErrorAlert(withMessage: error.displayableTitle)
                }
        })
    }
}

private extension ApiError {
    var displayableTitle: String {
        if title == "user already exists" {
             return "Username has already been taken."
        } else {
            return ApiError.unknown.title
        }
    }
}

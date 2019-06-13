protocol DeathViewModelDelegate: AnyObject {
    func dismiss()
}

class DeathViewModel {
    weak var delegate: DeathViewModelDelegate!
    let username: String
    
    init(user: User) {
        self.username = user.name
    }
    
    func didTapBackButton() {
        delegate.dismiss()
    }
}

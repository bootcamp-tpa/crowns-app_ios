protocol DeathViewInteractorDelegate: AnyObject {
    func dismiss()
}

class DeathViewInteractor {
    weak var delegate: DeathViewInteractorDelegate!
    let username: String
    
    init(user: User) {
        self.username = user.name
    }
    
    func didTapBackButton() {
        delegate.dismiss()
    }
}

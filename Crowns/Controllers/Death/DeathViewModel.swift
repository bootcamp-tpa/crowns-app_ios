protocol DeathViewModelDelegate: AnyObject {
    func dismiss()
}

class DeathViewModel {
    weak var delegate: DeathViewModelDelegate!
    let username: String
    
    init(user: User, kingAge: Int) {
        self.username = user.name
    }
    
    func didTapBackButton() {
        delegate.dismiss()
    }
}

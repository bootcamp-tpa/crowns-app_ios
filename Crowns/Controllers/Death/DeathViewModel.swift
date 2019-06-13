protocol DeathViewModelDelegate: AnyObject {
    func dismissToCrownMeController()
}

class DeathViewModel {
    weak var delegate: DeathViewModelDelegate!
    let username: String
    let score: String
    
    init(user: User, kingAge: Int) {
        self.username = user.name
        let startingYear = 1600
        self.score = "\(startingYear) - \(startingYear + kingAge)"
    }
    
    func didTapBackButton() {
        delegate.dismissToCrownMeController()
    }
}

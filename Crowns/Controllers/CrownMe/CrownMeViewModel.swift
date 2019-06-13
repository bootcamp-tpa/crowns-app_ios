protocol CrownMeViewModelDelegate: AnyObject {
    func showGameController(forUser user: User)
}

final class CrownMeViewModel {
    weak var delegate: CrownMeViewModelDelegate!
    var username: String { return user.name }
    private let user: User
    
    init(user: User) {
        self.user = user
    }
    
    func didTapCrownMeButton() {
        delegate.showGameController(forUser: user)
    }
}

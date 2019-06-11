protocol GameViewInteractorDelegate: AnyObject {
    
}

class GameViewInteractor {
    weak var delegate: GameViewInteractorDelegate!
    let username: String
    
    init(user: User) {
        self.username = user.name
    }
    
    func didSwipeCardToLeft() {
        
    }
    
    func didSwipeCardToRight() {
        
    }
    
}

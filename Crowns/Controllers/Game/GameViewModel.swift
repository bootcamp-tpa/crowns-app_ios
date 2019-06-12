protocol GameViewModelDelegate: AnyObject {
    
}

class GameViewModel {
    weak var delegate: GameViewModelDelegate!
    let username: String
    
    init(user: User) {
        self.username = user.name
    }
    
    func didSwipeCardToLeft() {
        
    }
    
    func didSwipeCardToRight() {
        
    }
    
}

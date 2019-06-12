protocol GameViewModelDelegate: AnyObject {
  func updateFactionsScore(withChange change: FactionScoreViewChange)
  func updateCard(withModel model: CardViewModel)
  func updateGameStats(withModel model: GameStatsViewModel)
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

    func factionsScoreViewModel(for choice: Choice) -> FactionsScoreViewModel {
        let model = FactionsScoreViewModel(
            churchModifierMode: .increase,
            commonersModifierMode: .none,
            militaryModifierMode: .decrease,
            merchantsModifierMode: .decrease
        )
        switch choice {
        case .none: return .empty
        default: return model
        }
    }

    func choiceName(for choice: Choice) -> String {
        return "MOCK"
    }

}

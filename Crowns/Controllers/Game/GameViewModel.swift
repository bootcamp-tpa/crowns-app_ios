protocol GameViewModelDelegate: AnyObject, LoadableViewModelDelegate {
    func updateFactionsScore(withModel model: FactionsScoreViewModel)
    func updateCard(withModel model: CardViewModel?)
    func updateGameStats(withModel model: GameStatsViewModel)
    func showErrorAlert(withMessage message: String)
    func showDeathController(forUser user: User, finishedGame: Game)
}

class GameViewModel {
    weak var delegate: GameViewModelDelegate!
    var username: String { return user.name }
    
    private let user: User
    private let storage: JSONStorage
    private let webService: WebService
    
    private var gameController: GameController!

    init(
        user: User,
        storage: JSONStorage,
        webService: WebService
    ) {
        self.user = user
        self.storage = storage
        self.webService = webService
    }
    
    func viewDidLoad() {
        startGame()
    }
    
    private func startGame() {
        updateDelegateWithInitialValues()
        if let game = storage.getGame() {
            gameController = GameController(game: game)
            updateDelegate()
        } else {
            attemptToCreateNewGame()
        }
    }
    
    private func updateDelegateWithInitialValues() {
        delegate.updateFactionsScore(withModel: .initial)
        delegate.updateCard(withModel: nil)
        delegate.updateGameStats(withModel: .initial)
    }
    
    private func attemptToCreateNewGame() {
        delegate.showLoadingIndicator(true)
        webService.createGame(completion: { [weak self] result in
            self?.delegate.showLoadingIndicator(false)
            switch result {
            case .success(let deck): self?.attemptToCreateGame(withDeck: deck)
            case .failure(let error): self?.delegate.showErrorAlert(withMessage: error.title)
            }
        })
    }
    
    private func attemptToCreateGame(withDeck deck: Deck) {
        if let firstCard = deck.cards.first {
            let game = Game(currentCard: firstCard, cards: deck.cards)
            gameController = GameController(game: game)
            updateDelegate()
        } else {
            delegate.showErrorAlert(withMessage: ApiError.unknown.title)
        }
    }
    
    func factionsScoreViewModes(for choice: Choice) -> FactionsScoreViewModes {
        guard let card = gameController.game.currentCard else { return .none }
        switch choice {
        case .left: return mapChoiceToFactionsScoreViewModes(card.leftChoice)
        case .right: return mapChoiceToFactionsScoreViewModes(card.rightChoice)
        case .none: return .none
        }
    }
    
    func choiceName(for choice: Choice) -> String? {
        guard let card = gameController.game.currentCard else { return nil }
        switch choice {
        case .left: return card.leftChoice.choiceText
        case .right: return card.rightChoice.choiceText
        case .none: return nil
        }
    }

    func didSwipeCard(withChoice choice: Choice) {
        guard let cardChoice = cardChoice(forGestureChoice: choice) else { return }
        let outcome = gameController.playTurn(forChoice: cardChoice)
        switch outcome {
        case .death:
            finishGame()
        case .success:
            updateDelegate()
            storeGame()
        }
    }
    
    private func cardChoice(forGestureChoice choice: Choice) -> CardChoice? {
        guard let currentCard = gameController.game.currentCard else { return nil }
        switch choice {
        case .left: return currentCard.leftChoice
        case .right: return currentCard.rightChoice
        case .none: return nil
        }
    }
    
    private func finishGame() {
        storage.store(game: nil)
        delegate.showDeathController(forUser: user, finishedGame: gameController.game)
    }
    
    private func updateDelegate() {
        let game = gameController.game
        guard let currentCard = game.currentCard else { return }
        delegate.updateCard(withModel: mapCardToCardViewModel(currentCard))
        delegate.updateFactionsScore(withModel: mapGameToFactionsScoreViewModel(game))
        delegate.updateGameStats(withModel: mapGameToGameStatsViewModel(game))
    }
    
    private func storeGame() {
        storage.store(game: gameController.game)
    }
}

private func mapChoiceToFactionsScoreViewModes(_ choice: CardChoice) -> FactionsScoreViewModes {
    return FactionsScoreViewModes(
        churchModifierMode: modifierMode(from: choice.churchModifier ?? 0),
        commonersModifierMode: modifierMode(from: choice.commonersModifier),
        militaryModifierMode: modifierMode(from: choice.militaryModifier),
        merchantsModifierMode: modifierMode(from: choice.merchantsModifier)
    )
}

private func modifierMode(from modifier: Int) -> ModifierMode {
    if modifier > 0 {
        return .increase
    } else if modifier < 0 {
        return .decrease
    } else {
        return .none
    }
}

private func mapCardToCardViewModel(_ card: Card) -> CardViewModel {
    return CardViewModel(
        title: card.cardText,
        image: card.cardImage.rawValue
    )
}

private func mapGameToGameStatsViewModel(_ game: Game) -> GameStatsViewModel {
    return GameStatsViewModel(
        score: String(game.score),
        years: String(game.kingAge - GameController.initialKingAge)
    )
}

private func mapGameToFactionsScoreViewModel(_ game: Game) -> FactionsScoreViewModel {
    return FactionsScoreViewModel(
        churchScore: game.churchScore,
        commonersScore: game.commonersScore,
        militaryScore: game.militaryScore,
        merchantsScore: game.merchantsScore
    )
}

private extension FactionsScoreViewModel {
    static var initial: FactionsScoreViewModel {
        return FactionsScoreViewModel(
            churchScore: GameController.initialFactionScore,
            commonersScore: GameController.initialFactionScore,
            militaryScore: GameController.initialFactionScore,
            merchantsScore: GameController.initialFactionScore
        )
    }
}

private extension GameStatsViewModel {
    static var initial: GameStatsViewModel {
        return GameStatsViewModel(
            score: String(GameController.initialScore),
            years: String(0)
        )
    }
}

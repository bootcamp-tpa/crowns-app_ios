protocol GameViewModelDelegate: AnyObject {
    func updateFactionsScore(withModel model: FactionsScoreViewModel)
    func updateCard(withModel model: CardViewModel?)
    func updateGameStats(withModel model: GameStatsViewModel)
    func showLoadingIndicator(_ show: Bool)
    func showErrorAlert(withMessage message: String)
    func showDeathController(forUser user: User, kingAge: Int)
}

class GameViewModel {
    weak var delegate: GameViewModelDelegate!
    var username: String { return user.name }
    private var game: Game!
    private let user: User
    private let storage: JSONStorage
    private let webService: WebService
    private let maxKingAge = 114

    init(
        user: User,
        storage: JSONStorage,
        webService: WebService
    ) {
        self.user = user
        self.storage = storage
        self.webService = webService
    }
    
    func viewWillAppear() {
        startGame()
    }
    
    private func startGame() {
        updateDelegateWithInitialValues()
        if let game = storage.getGame() {
            self.game = game
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
            switch result {
            case .success(let deck): self?.attemptToCreateGame(withDeck: deck)
            case .failure(let error): self?.delegate.showErrorAlert(withMessage: error.title)
            }
        })
    }
    
    private func attemptToCreateGame(withDeck deck: Deck) {
        if let firstCard = deck.cards.first {
            game = Game(currentCard: firstCard, cards: deck.cards)
            updateDelegate()
        } else {
            delegate.showErrorAlert(withMessage: ApiError.unknown.title)
        }
    }
    
    func factionsScoreViewModes(for choice: Choice) -> FactionsScoreViewModes {
        guard let card = game.currentCard else { return .none }
        switch choice {
        case .left: return mapChoiceToFactionsScoreViewModes(card.leftChoice)
        case .right: return mapChoiceToFactionsScoreViewModes(card.rightChoice)
        case .none: return .none
        }
    }
    
    func choiceName(for choice: Choice) -> String? {
        guard let card = game.currentCard else { return nil }
        switch choice {
        case .left: return card.leftChoice.choiceText
        case .right: return card.leftChoice.choiceText
        case .none: return nil
        }
    }

    func didSwipeCard(withChoice choice: Choice) {
        guard let currentCard = game.currentCard else { return }
        switch choice {
        case .left: update(withChoice: currentCard.leftChoice)
        case .right: update(withChoice: currentCard.rightChoice)
        case .none: return
        }
    }
    
    private func update(withChoice choice: CardChoice) {
        updateGame(withChoice: choice)
        if shouldFinishGame() {
            finishGame()
        } else {
            updateDelegate()
            storeGame()
        }
    }
    
    private func updateGame(withChoice choice: CardChoice) {
        game.churchScore += choice.churchModifier
        game.commonersScore += choice.commonersModifier
        game.militaryScore += choice.militaryModifier
        game.merchantsScore += choice.merchantsModifier
        game.score += choice.bonusModifier
        game.turnsPlayed += 1
        if game.turnsPlayed % 3 == 0 { game.kingAge += 1 }
        game.currentCard = choice.nextCard ?? game.cards.first
        game.cards = Array(game.cards.dropFirst())
    }
    
    private func shouldFinishGame() -> Bool {
        return game.currentCard == nil
            || game.currentCard!.cardType == .death
            || game.kingAge > maxKingAge
    }
    
    private func finishGame() {
        storage.store(game: nil)
        delegate.showDeathController(forUser: user, kingAge: game.kingAge)
    }
    
    private func updateDelegate() {
        guard let currentCard = game.currentCard else { return }
        delegate.updateCard(withModel: mapCardToCardViewModel(currentCard))
        delegate.updateFactionsScore(withModel: mapGameToFactionsScoreViewModel(game))
        delegate.updateGameStats(withModel: mapGameToGameStatsViewModel(game))
    }
    
    private func storeGame() {
        storage.store(game: game)
    }
}

private func mapChoiceToFactionsScoreViewModes(_ choice: CardChoice) -> FactionsScoreViewModes {
    return FactionsScoreViewModes(
        churchModifierMode: modifierMode(from: choice.churchModifier),
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
        years: String(game.kingAge - Game.initialKingAge)
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
            churchScore: Game.initialFactionScore,
            commonersScore: Game.initialFactionScore,
            militaryScore: Game.initialFactionScore,
            merchantsScore: Game.initialFactionScore
        )
    }
}

private extension GameStatsViewModel {
    static var initial: GameStatsViewModel {
        return GameStatsViewModel(
            score: String(Game.initialScore),
            years: String(0)
        )
    }
}

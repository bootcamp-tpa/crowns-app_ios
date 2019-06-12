protocol GameViewModelDelegate: AnyObject {
    func updateFactionsScore(withChange change: FactionScoreViewChange)
    func updateCard(withModel model: CardViewModel)
    func updateGameStats(withModel model: GameStatsViewModel)
    func showDeathController(forUser user: User, kingAge: Int)
}

class GameViewModel {
    weak var delegate: GameViewModelDelegate!
    var username: String { return user.name }
    private var game: Game!
    private let user: User
    private let storage: JSONStorage
    private let maxKingAge = 114

    init(user: User, storage: JSONStorage) {
        self.user = user
        self.storage = storage
    }
    
    func viewDidLoad() {
        
    }
    
    func factionsScoreViewModel(for choice: Choice) -> FactionsScoreViewModel {
        guard let card = game.currentCard else { return .empty }
        switch choice {
        case .left: return mapChoiceToFactionsScoreViewModel(card.leftChoice)
        case .right: return mapChoiceToFactionsScoreViewModel(card.rightChoice)
        case .none: return .empty
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
        finishGameIfNeeded()
        updateDelegate(withChoice: choice)
        storeGame()
    }
    
    private func updateGame(withChoice choice: CardChoice) {
        game.churchScore += choice.churchModifier
        game.commonersScore += choice.commonersModifier
        game.militaryScore += choice.militaryModifier
        game.merchantsScore += choice.merchantsModifier
        game.score += choice.bonusModifier
        game.turnsPlayed += 1
        if game.turnsPlayed % 3 == 0 { game.kingAge += 1 }
        game.currentCard = choice.nextCard ?? game.cards.dropFirst().first
    }
    
    private func finishGameIfNeeded() {
        if game.currentCard == nil
           || game.currentCard!.cardType == .death
           || game.kingAge > maxKingAge {
            storage.store(game: nil)
            delegate.showDeathController(forUser: user, kingAge: game.kingAge)
        }
    }
    
    private func updateDelegate(withChoice choice: CardChoice) {
        guard let currentCard = game.currentCard else { return }
        delegate.updateCard(withModel: mapCardToCardViewModel(currentCard))
        // TODO: factions
        delegate.updateGameStats(withModel: mapGameToGameStatsViewModel(game))
    }
    
    private func storeGame() {
        storage.store(game: game)
    }
}

private func mapChoiceToFactionsScoreViewModel(_ choice: CardChoice) -> FactionsScoreViewModel {
    return FactionsScoreViewModel(
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

private func mapChoiceToFactionScoreViewChange(_ choice: CardChoice) -> FactionScoreViewChange {
    return FactionScoreViewChange(
        faction: <#T##Faction#>, score: <#T##Int#>)
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
        years: String(game.kingAge)
    )
}

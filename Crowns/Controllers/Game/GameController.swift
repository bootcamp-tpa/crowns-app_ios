enum TurnOutcome {
    case success
    case death
}

class GameController {
    static var initialScore: Int { return 0 }
    static var initialKingAge: Int { return 14 }
    static var initialFactionScore: Int { return 50 }
    static var maxKingAge: Int { return 114 }
    
    private(set) var game: Game
    
    init(game: Game) {
        self.game = game
    }
    
    func playTurn(forChoice choice: CardChoice) -> TurnOutcome {
        updateGame(withChoice: choice)
        return getTurnOutcome()
    }
    
    private func updateGame(withChoice choice: CardChoice) {
        game.churchScore += choice.churchModifier
        game.commonersScore += choice.commonersModifier
        game.militaryScore += choice.militaryModifier
        game.merchantsScore += choice.merchantsModifier
        game.kingAge += choice.bonusModifier
        game.turnsPlayed += 1
        if game.turnsPlayed % 3 == 0 {
            game.kingAge += 1
            game.score += 1
        }
        game.currentCard = choice.nextCard ?? game.cards.first
        game.cards = Array(game.cards.dropFirst())
    }
    
    private func getTurnOutcome() -> TurnOutcome {
        if game.currentCard == nil
           || game.currentCard!.cardType == .death
           || game.kingAge > GameController.maxKingAge
           || game.factionScores.contains(where: { $0 >= 100 || $0 <= 0 }) {
            return .death
        } else {
            return .success
        }
    }
    
}

struct Game: Codable {    
    var factionScores: [Int] {
        return [
            churchScore,
            commonersScore,
            militaryScore,
            merchantsScore
        ]
    }
    
    var currentCard: Card?
    var cards: [Card]
    var turnsPlayed = 0
    var score = GameController.initialScore
    var kingAge = GameController.initialKingAge
    var churchScore = GameController.initialFactionScore
    var commonersScore = GameController.initialFactionScore
    var militaryScore = GameController.initialFactionScore
    var merchantsScore = GameController.initialFactionScore
    
    init(currentCard: Card, cards: [Card]) {
        self.currentCard = currentCard
        self.cards = cards
    }
}

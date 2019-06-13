struct Game: Codable {
    static var initialScore: Int { return 0 }
    static var initialKingAge: Int { return 14 }
    static var initialFactionScore: Int { return 50 }
    
    var currentCard: Card?
    var cards: [Card]
    var turnsPlayed = 0
    var score = Game.initialScore
    var kingAge = Game.initialKingAge
    var churchScore = Game.initialFactionScore
    var commonersScore = Game.initialFactionScore
    var militaryScore = Game.initialFactionScore
    var merchantsScore = Game.initialFactionScore
    
    init(currentCard: Card, cards: [Card]) {
        self.currentCard = currentCard
        self.cards = cards
    }
}

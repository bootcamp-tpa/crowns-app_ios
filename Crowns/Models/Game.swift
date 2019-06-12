struct Game: Codable {
    var currentCard: Card?
    var cards: [Card]
    var turnsPlayed = 0
    var score = 0
    var kingAge = 14
    var churchScore = 50
    var commonersScore = 50
    var militaryScore = 50
    var merchantsScore = 50
    
    init(currentCard: Card, cards: [Card]) {
        self.currentCard = currentCard
        self.cards = cards
    }
}

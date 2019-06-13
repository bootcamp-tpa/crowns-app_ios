class CardChoice: Codable {
    let nextCard: Card?
    let choiceText: String
    let churchModifier: Int
    let commonersModifier: Int
    let merchantsModifier: Int
    let militaryModifier: Int
    let bonusModifier: Int
    
    // TODO: remove once api is connected
    init(
        nextCard: Card?,
        choiceText: String,
        churchModifier: Int,
        commonersModifier: Int,
        merchantsModifier: Int,
        militaryModifier: Int,
        bonusModifier: Int
    ) {
        self.nextCard = nextCard
        self.choiceText = choiceText
        self.churchModifier = churchModifier
        self.commonersModifier = commonersModifier
        self.merchantsModifier = merchantsModifier
        self.militaryModifier = militaryModifier
        self.bonusModifier = bonusModifier
    }
}

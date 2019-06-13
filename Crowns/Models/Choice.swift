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
    
    static func mock(
        nextCard: Card? = nil,
        choiceText: String = "Choice title",
        churchModifier: Int = 15,
        commonersModifier: Int = -20,
        merchantsModifier: Int = 0,
        militaryModifier: Int = 10,
        bonusModifier: Int = 5
    ) -> CardChoice {
        return CardChoice(
            nextCard: nextCard,
            choiceText: choiceText,
            churchModifier: churchModifier,
            commonersModifier: commonersModifier,
            merchantsModifier: merchantsModifier,
            militaryModifier: militaryModifier,
            bonusModifier: bonusModifier
        )
    }
}

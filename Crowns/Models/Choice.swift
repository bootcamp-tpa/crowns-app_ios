class CardChoice: Codable {
    let nextCard: Card?
    let choiceText: String
    let churchModifier: Int
    let commonersModifier: Int
    let merchantsModifier: Int
    let militaryModifier: Int
    let bonusModifier: Int
}

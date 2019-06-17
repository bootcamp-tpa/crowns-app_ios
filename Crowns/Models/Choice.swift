class CardChoice: Codable {
    let next: Card?
    let choiceText: String
    var churchModifier: Int?
    let commonersModifier: Int
    let merchantsModifier: Int
    let militaryModifier: Int
    let bonusModifier: Int?
}

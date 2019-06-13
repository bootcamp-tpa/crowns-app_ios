struct Card: Codable {
    enum CardType: String, Codable {
        case event = "EVENT"
        case death = "DEATH"
    }
    
    enum Image: String, Codable {
        case church = "CHURCH"
        case church2 = "CHURCH_2"
        case etc = "ETC"
        case etc2 = "ETC_2"
        case misc = "MISC"
        case misc2 = "MISC_2"
        case treasury = "TREASURY"
        case treasury2 = "TREASURY_2"
    }
    
    let id: Int
    let cardText: String
    let cardType: CardType
    let cardImage: Image
    let leftChoice: CardChoice
    let rightChoice: CardChoice
}

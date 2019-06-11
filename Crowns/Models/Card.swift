struct Card: Decodable {
    enum `Type`: String, Decodable {
        case event = "EVENT"
        case death = "DEATH"
    }
    
    let cardText: String
    let cardType: Type
}

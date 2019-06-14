struct Highscores: Codable {
    let highscores: [Highscore]
}

struct Highscore: Codable {
    struct Scores: Codable {
        let church: Int
        let commoners: Int
        let military: Int
        let merchants: Int
        let bonus: Int
    }
    
    let name: String
    let age: Int
    let submitedAt: Int
    let start: Int
    let scores: Scores
}

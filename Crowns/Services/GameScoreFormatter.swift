protocol GameScoreFormatter {
    func formattedScore(forAge kingAge: Int) -> String
}

struct GameScoreFormatterImp: GameScoreFormatter {
    func formattedScore(forAge kingAge: Int) -> String {
        let yearsRuling = kingAge - GameController.initialKingAge
        let initialYear = GameController.initialYear
        let deathYear = initialYear + yearsRuling
        return "\(initialYear) - \(deathYear)"
    }
}

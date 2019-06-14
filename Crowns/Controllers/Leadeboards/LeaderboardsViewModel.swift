import Foundation

protocol LeaderboardsViewModelDelegate: AnyObject {
    func reloadTable()
}

class LeaderboardsViewModel {
    weak var delegate: LeaderboardsViewModelDelegate!
    private let highscores: Highscores
    private let webService: WebService
    private let scoreFormatter: GameScoreFormatter
    
    init(
        highscores: Highscores,
        webService: WebService,
        scoreFormatter: GameScoreFormatter
    ) {
        self.highscores = highscores
        self.webService = webService
        self.scoreFormatter = scoreFormatter
    }
    
    func didPullToRefresh() {
        
    }
    
    func numberOfCells() -> Int {
        return highscores.highscores.count
    }
    
    func cellModel(atIndexPath indexPath: IndexPath) -> HighscoreCellModel {
        let index = indexPath.row
        let highscore = highscores.highscores[index]
        return HighscoreCellModel(
            rank: String(index),
            username: highscore.name,
            score: mapHighscoreToScoreString(highscore)
        )
    }
    
    private func mapHighscoreToScoreString(_ highscore: Highscore) -> String {
        let ruledFor = highscore.age - GameController.initialKingAge
        let yearsString = ruledFor > 1 ? "years" : "year"
        let ruledForString = "\(ruledFor) \(yearsString) in power"
        let scoreString = scoreFormatter.formattedScore(forAge: highscore.age)
        return ruledForString + " " + scoreString
    }
}

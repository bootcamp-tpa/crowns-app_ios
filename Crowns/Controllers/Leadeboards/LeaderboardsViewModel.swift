import Foundation

protocol LeaderboardsViewModelDelegate: AnyObject {
    func reloadTable()
    func showErrorAlert(withMessage message: String)
}

class LeaderboardsViewModel {
    weak var delegate: LeaderboardsViewModelDelegate!
    private var highscores: Highscores
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
        webService.getHighscores(completion: { [weak self] response in
            switch response {
            case .success(let highscores):
                self?.highscores = highscores
                self?.delegate.reloadTable()
            case .failure(let error):
                self?.delegate.showErrorAlert(withMessage: error.title)
            }
        })
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
        let yearsString = ruledFor == 1 ? "year" : "years"
        let ruledForString = "\(ruledFor) \(yearsString) in power"
        let scoreString = scoreFormatter.formattedScore(forAge: highscore.age)
        return ruledForString + " " + scoreString
    }
}

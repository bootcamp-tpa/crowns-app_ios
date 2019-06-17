import Foundation

protocol LeaderboardsViewModelDelegate: AnyObject {
    func endRefreshing()
    func reloadTable()
    func showAlert(withModel model: AlertControllerModel)
}

class LeaderboardsViewModel {
    weak var delegate: LeaderboardsViewModelDelegate!
    private var highscores: [Highscore]
    private let webService: WebService
    private let scoreFormatter: GameScoreFormatter
    
    init(
        highscores: [Highscore],
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
                self?.delegate.endRefreshing()
                self?.delegate.reloadTable()
            case .failure(let error):
                self?.delegate.showAlert(withModel: .plain(withMessage: error.title))
            }
        })
    }
    
    func numberOfCells() -> Int {
        return highscores.count
    }
    
    func cellModel(atIndexPath indexPath: IndexPath) -> HighscoreCellModel {
        let index = indexPath.row
        let highscore = highscores[index]
        return HighscoreCellModel(
            rank: String(index + 1),
            username: highscore.name,
            score: mapHighscoreToScoreString(highscore)
        )
    }
    
    private func mapHighscoreToScoreString(_ highscore: Highscore) -> String {
        let ruledFor = highscore.age - GameController.initialKingAge
        let format = NSLocalizedString("%d years in power", comment: "")
        let ruledForString = String.localizedStringWithFormat(format, ruledFor)
        let scoreString = scoreFormatter.formattedScore(forAge: highscore.age)
        return ruledForString + " " + scoreString
    }
}

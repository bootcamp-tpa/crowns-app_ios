protocol DeathViewModelDelegate: AnyObject, LoadableViewModelDelegate {
    func dismissToCrownMeController()
    func showErrorAlert(withMessage message: String)
    func showLeaderboardsController(withHighscores highscores: Highscores)
}

class DeathViewModel {
    weak var delegate: DeathViewModelDelegate!
    var username: String { return user.name }
    let score: String
    private let user: User
    private let finishedGame: Game
    private let webService: WebService
    
    init(
        user: User,
        finishedGame: Game,
        webService: WebService,
        scoreFormatter: GameScoreFormatter
    ) {
        self.user = user
        self.finishedGame = finishedGame
        self.webService = webService
        self.score = scoreFormatter.formattedScore(forAge: finishedGame.kingAge)
    }
    
    func viewDidLoad() {
        webService.submitHighscore(
            mapGameToHighscore(finishedGame, forUser: user),
            completion: { _ in }
        )
    }
    
    func didTapCheckLeaderboardsButton() {
        delegate.showLoadingIndicator(true)
        webService.getHighscores(completion: { [delegate] response in
            delegate?.showLoadingIndicator(false)
            switch response {
            case .success(let highscores): delegate?.showLeaderboardsController(withHighscores: highscores)
            case .failure(let error): delegate?.showErrorAlert(withMessage: error.title)
            }
        })
    }
    
    func didTapBackButton() {
        delegate.dismissToCrownMeController()
    }
}

private func mapGameToHighscore(_ game: Game, forUser user: User) -> Highscore {
    let scores = Highscore.Scores(
        church: game.churchScore,
        commoners: game.commonersScore,
        military: game.militaryScore,
        merchants: game.merchantsScore,
        bonus: game.score
    )
    return Highscore(
        name: user.name,
        age: game.kingAge,
        submittedAt: 0,
        start: GameController.initialYear,
        scores: scores
    )
}

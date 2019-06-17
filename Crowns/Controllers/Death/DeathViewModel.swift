protocol DeathViewModelDelegate: AnyObject {
    func showLoadingIndicator(_ show: Bool)
    func dismissToCrownMeController()
    func showAlert(withModel model: AlertControllerModel)
    func showLeaderboardsController(withHighscores highscores: [Highscore])
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
        submitHighscore()
    }
    
    private func submitHighscore() {
        delegate.showLoadingIndicator(true)
        webService.submitHighscore(
            mapGameToHighscore(finishedGame, forUser: user),
            completion: { [weak self] response in
                self?.delegate.showLoadingIndicator(false)
                switch response {
                case .success: break
                case .failure: self?.showRetryAlert()
                }
            }
        )
    }
    
    private func showRetryAlert() {
        let cancelActionModel = AlertActionModel(
            title: "Cancel",
            style: .default,
            handler: nil
        )
        let retryActionModel = AlertActionModel(
            title: "Retry",
            style: .cancel,
            handler: { [weak self] _ in
                self?.submitHighscore()
        })
        let alertModel = AlertControllerModel(
            title: "We were not able to submit your highscore.",
            message: "Do you wish to retry?",
            actionsModels: [cancelActionModel, retryActionModel]
        )
        delegate.showAlert(withModel: alertModel)
    }
    
    func didTapCheckLeaderboardsButton() {
        delegate.showLoadingIndicator(true)
        webService.getHighscores(completion: { [delegate] response in
            delegate?.showLoadingIndicator(false)
            switch response {
            case .success(let highscores): delegate?.showLeaderboardsController(withHighscores: highscores)
            case .failure(let error): delegate?.showAlert(withModel: .plain(withMessage: error.title))
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
        start: GameController.initialYear,
        scores: scores
    )
}

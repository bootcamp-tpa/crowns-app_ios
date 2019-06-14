protocol DeathViewModelDelegate: AnyObject, LoadableViewModelDelegate {
    func dismissToCrownMeController()
    func showLeaderboardsController(withHighscores highscores: Highscores)
}

class DeathViewModel {
    weak var delegate: DeathViewModelDelegate!
    let username: String
    let score: String
    private let webService: WebService
    
    init(
        user: User,
        finishedGame: Game,
        webService: WebService,
        scoreFormatter: GameScoreFormatter
    ) {
        self.username = user.name
        self.webService = webService
        self.score = scoreFormatter.formattedScore(forAge: finishedGame.kingAge)
    }
    
    func viewDidLoad() {
        
    }
    
    func didTapCheckLeaderboardsButton() {
        
    }
    
    func didTapBackButton() {
        delegate.dismissToCrownMeController()
    }
}

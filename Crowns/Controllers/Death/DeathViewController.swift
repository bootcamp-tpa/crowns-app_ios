import UIKit

class DeathViewController: UIViewController {
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var usernameLabel: UILabel!
    @IBOutlet private weak var scoreLabel: UILabel!
    
    private var viewModel: DeathViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLabelsText()
        viewModel.viewDidLoad()
    }
    
    private func setLabelsText() {
        usernameLabel.text = viewModel.username
        scoreLabel.text = viewModel.score
    }
    
    @IBAction private func didTapCheckLeaderboardsButton(_ sender: Any) {
        viewModel.didTapCheckLeaderboardsButton()
    }
    
    @IBAction private func didTapBackButton(_ sender: Any) {
        viewModel.didTapBackButton()
    }
}

extension DeathViewController: DeathViewModelDelegate {
    func showLoadingIndicator(_ show: Bool) {
        if show {
            loadingIndicator.startAnimating()
        } else {
            loadingIndicator.stopAnimating()
        }
    }
    
    func dismissToCrownMeController() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    func showLeaderboardsController(withHighscores highscores: [Highscore]) {
        let controller = LeaderboardsViewController.instantiate(withHighscores: highscores)
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension DeathViewController {
    static func instantiate(withUser user: User, finishedGame: Game) -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let controller = storyboard.instantiateViewController(withIdentifier: "DeathViewController") as! DeathViewController
        let viewModel = DeathViewModel(
            user: user,
            finishedGame: finishedGame,
            webService: WebServiceImp(),
            scoreFormatter: GameScoreFormatterImp()
        )
        controller.viewModel = viewModel
        viewModel.delegate = controller
        return controller
    }
}

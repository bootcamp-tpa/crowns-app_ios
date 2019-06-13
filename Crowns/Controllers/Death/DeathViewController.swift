import UIKit

class DeathViewController: UIViewController {
    @IBOutlet private weak var usernameLabel: UILabel!
    @IBOutlet private weak var scoreLabel: UILabel!
    
    private var viewModel: DeathViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLabelsText()
    }
    
    private func setLabelsText() {
        usernameLabel.text = viewModel.username
        scoreLabel.text = viewModel.score
    }
    
    @IBAction private func didTapBackButton(_ sender: Any) {
        viewModel.didTapBackButton()
    }
}

extension DeathViewController: DeathViewModelDelegate {
    func dismissToCrownMeController() {
        let crownMeController = findCrownMeControllerInHierarchy()
        crownMeController?.dismiss(animated: true)
    }
}

private extension UIViewController {
    func findCrownMeControllerInHierarchy() -> UIViewController? {
        if let crownMeController = presentingViewController as? CrownMeViewController {
            return crownMeController
        } else {
            return presentingViewController?.findCrownMeControllerInHierarchy()
        }
    }
}

extension DeathViewController {
    static func instantiate(withUser user: User, kingAge: Int) -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let controller = storyboard.instantiateViewController(withIdentifier: "DeathViewController") as! DeathViewController
        let viewModel = DeathViewModel(user: user, kingAge: kingAge)
        controller.viewModel = viewModel
        viewModel.delegate = controller
        return controller
    }
}

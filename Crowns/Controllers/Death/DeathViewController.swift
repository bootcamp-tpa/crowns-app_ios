import UIKit

class DeathViewController: UIViewController {
    @IBOutlet private weak var usernameLabel: UILabel!
    @IBOutlet private weak var scoreLabel: UILabel!
    
    private var viewModel: DeathViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameLabel.text = viewModel.username
    }
    
    @IBAction private func didTapBackButton(_ sender: Any) {
        viewModel.didTapBackButton()
    }
}

extension DeathViewController: DeathViewModelDelegate {
    func dismiss() {
        dismiss(animated: true)
    }
}

extension DeathViewController {
    static func instantiate(withUser user: User) -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let controller = storyboard.instantiateViewController(withIdentifier: "DeathViewController") as! DeathViewController
        let viewModel = DeathViewModel(user: user)
        controller.viewModel = viewModel
        viewModel.delegate = controller
        return controller
    }
}

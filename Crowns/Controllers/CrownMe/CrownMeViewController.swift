import UIKit

class CrownMeViewController: UIViewController {

    @IBOutlet weak var usernameLabel: UILabel!
    private var viewModel: CrownMeViewModel!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUsername()
    }
    
    private func setUsername() {
        usernameLabel.text = viewModel.username
    }
    
    @IBAction private func didTapCrownMeButton(_ sender: Any) {
        viewModel.didTapCrownMeButton()
    }
}

extension CrownMeViewController: CrownMeViewModelDelegate {
    func showGameController(forUser user: User) {
        let controller = GameViewController.instantiate(withUser: user)
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension CrownMeViewController {
    static func instantiate(withUser user: User) -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let controller = storyboard.instantiateViewController(withIdentifier: "CrownMeViewController") as! CrownMeViewController
        let viewModel = CrownMeViewModel(user: user)
        controller.viewModel = viewModel
        viewModel.delegate = controller
        return controller
    }
}

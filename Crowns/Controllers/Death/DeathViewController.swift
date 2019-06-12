import UIKit

class DeathViewController: UIViewController {
    @IBOutlet private weak var usernameLabel: UILabel!
    @IBOutlet private weak var scoreLabel: UILabel!
    
    private var interactor: DeathViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameLabel.text = interactor.username
    }
    
    @IBAction private func didTapBackButton(_ sender: Any) {
        interactor.didTapBackButton()
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
        let interactor = DeathViewModel(user: user)
        controller.interactor = interactor
        interactor.delegate = controller
        return controller
    }
}

import UIKit

class DeathViewController: UIViewController {
    @IBOutlet private weak var usernameLabel: UILabel!
    @IBOutlet private weak var scoreLabel: UILabel!
    
    private var interactor: DeathViewInteractor!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameLabel.text = interactor.username
    }
    
    @IBAction private func didTapBackButton(_ sender: Any) {
        dismiss(animated: true)
    }
}

extension DeathViewController {
    static func instantiate(withUser user: User) -> UIViewController {
        let controller: DeathViewController = .instantiate(storyboardId: "DeathViewController")
        controller.interactor = DeathViewInteractor(user: user)
        return controller
    }
}

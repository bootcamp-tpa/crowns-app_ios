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
        interactor.didTapBackButton()
    }
}

extension DeathViewController: DeathViewInteractorDelegate {
    func dismiss() {
        dismiss(animated: true)
    }
}

extension DeathViewController {
    static func instantiate(withUser user: User) -> UIViewController {
        let controller: DeathViewController = .instantiate(storyboardId: "DeathViewController")
        let interactor = DeathViewInteractor(user: user)
        controller.interactor = interactor
        interactor.delegate = controller
        return controller
    }
}

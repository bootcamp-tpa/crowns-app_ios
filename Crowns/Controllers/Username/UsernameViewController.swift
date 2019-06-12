import UIKit

class UsernameViewController: UIViewController {
    @IBOutlet private weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var startButton: UIButton!
    @IBOutlet private weak var usernameTextField: UITextField!
    
    private lazy var interactor: UsernameViewModel = {
        let interactor = UsernameViewModel(
            storage: JSONStorageImp(),
            webService: WebServiceImp()
        )
        interactor.delegate = self
        return interactor
    }()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // TODO - move to splash screen once created
        if let user = JSONStorageImp().getUser() {
            showGameController(forUser: user)
        }
    }

    @IBAction private func textFieldValueChanged(_ sender: UITextField) {
        interactor.textFieldValueDidChange(to: sender.text)
    }
    
    @IBAction private func textFieldDidEndOnExit(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    @IBAction private func didTapStartButton(_ sender: Any) {
        usernameTextField.resignFirstResponder()
        interactor.didTapStartButton()
    }
}

extension UsernameViewController: UsernameViewModelDelegate {
    func showLoadingIndicator(_ show: Bool) {
        if show {
            loadingIndicator.startAnimating()
        } else {
            loadingIndicator.stopAnimating()
        }
    }
    
    func enableStartButton(_ enable: Bool) {
        startButton.isEnabled = enable
        if enable {
            startButton.backgroundColor = UIColor(red: 219/255, green: 128/255, blue: 102/255, alpha: 1)
        } else {
            startButton.backgroundColor = .lightGray
        }
    }
    
    func showErrorAlert(withMessage message: String) {
        let controller = UIAlertController(title: "Ooops.", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel)
        controller.addAction(action)
        present(controller, animated: true)
    }
    
    func showGameController(forUser user: User) {
        let controller = GameViewController.instantiate(withUser: user)
        present(controller, animated: true)
    }
}

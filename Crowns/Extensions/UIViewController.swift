import UIKit

extension UIViewController {
    func showErrorAlert(withMessage message: String) {
        let controller = UIAlertController(title: "Ooops.", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel)
        controller.addAction(action)
        present(controller, animated: true)
    }
}

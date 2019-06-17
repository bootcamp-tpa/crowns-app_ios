import UIKit

extension UIViewController {
    func showAlert(withModel model: AlertControllerModel) {
        let controller = UIAlertController(model: model)
        present(controller, animated: true)
    }
}

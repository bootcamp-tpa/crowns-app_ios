import UIKit

class CustomNavigationController: UINavigationController {

    override var preferredStatusBarStyle: UIStatusBarStyle {
        if let topController = viewControllers.first {
            return topController.preferredStatusBarStyle
        } else {
            return .default
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        navigationBar.prefersLargeTitles = true
        navigationBar.titleTextAttributes = titleAttributes(withSize: 22)
        navigationBar.largeTitleTextAttributes = titleAttributes(withSize: 38)
        
        navigationBar.isTranslucent = false
        navigationBar.tintColor = UIColor(red: 0.83, green: 0.98, blue: 0.84, alpha: 1)
        navigationBar.barTintColor = UIColor(red: 0.25, green: 0.16, blue: 0.17, alpha: 1)
    }
    
    private func titleAttributes(withSize size: CGFloat) -> [NSAttributedString.Key: Any] {
        return [
            NSAttributedString.Key.foregroundColor: UIColor(red: 1, green: 0.24, blue: 0.41, alpha: 1),
            NSAttributedString.Key.font: UIFont(name: "CourierNewPS-BoldMT", size: size)!
        ]
    }
}

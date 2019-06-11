import UIKit

extension UIViewController {
    static func instantiate<T>(storyboardId: String) -> T {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        return storyboard.instantiateViewController(withIdentifier: storyboardId) as! T
    }
}

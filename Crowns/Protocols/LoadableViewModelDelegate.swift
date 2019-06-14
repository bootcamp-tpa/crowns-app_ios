import UIKit

protocol LoadableViewModelDelegate {
    func showLoadingIndicator(_ show: Bool)
}

protocol LoadableViewController {
    var loadingIndicator: UIActivityIndicatorView! { get }
}

extension LoadableViewModelDelegate where Self: LoadableViewController {
    func showLoadingIndicator(_ show: Bool) {
        if show {
            loadingIndicator.startAnimating()
        } else {
            loadingIndicator.stopAnimating()
        }
    }
}

import UIKit

struct AlertControllerModel {
    let title: String
    let message: String
    let actionsModels: [AlertActionModel]
    
    static func plain(withMessage message: String) -> AlertControllerModel {
        let okAction = AlertActionModel(
            title: "Ok",
            style: .cancel,
            handler: nil
        )
        return AlertControllerModel(
            title: "Ooops",
            message: message,
            actionsModels: [okAction]
        )
    }
}

struct AlertActionModel {
    let title: String?
    let style: UIAlertAction.Style
    let handler: ((UIAlertAction) -> Void)?
}

extension UIAlertController {
    convenience init(model: AlertControllerModel) {
        self.init(title: model.title, message: model.message, preferredStyle: .alert)
        model.actionsModels
            .map { actionModel in
                return UIAlertAction(
                    title: actionModel.title,
                    style: actionModel.style,
                    handler: actionModel.handler
                )
            }
            .forEach { action in
                addAction(action)
            }
    }
}

import UIKit

protocol BaseViewControllerProtocol: class {
    func displayMessage(title: String, message: String)
    func displayMessageWithCallback(
        title: String,
        message: String,
        callback: @escaping () -> Void
    )
}

class BaseViewController: UIViewController, BaseViewControllerProtocol {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func displayMessage(title: String, message: String) {
        let alert = AlertBuilder()
            .setTitle(title)
            .setMessage(message)
            .setOkButtn("ok", callback: {})
            .build()
        present(alert, animated: true, completion: nil)
    }
    
    func displayMessageWithCallback(
        title: String,
        message: String,
        callback: @escaping () -> Void
    ) {
        let alert = AlertBuilder()
            .setTitle(title)
            .setMessage(message)
            .setOkButtn("ok", callback: callback)
            .build()
        present(alert, animated: true, completion: nil)
    }
}

class AlertBuilder {
    let alertVC = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
    func setTitle(_ title: String) -> AlertBuilder {
        alertVC.title = title
        return self
    }
    
    func setMessage(_ message: String) -> AlertBuilder {
        alertVC.message = message
        return self
    }
    
    func setOkButtn(_ buttonTitle: String, callback: @escaping () -> Void?) -> AlertBuilder {
        alertVC.addAction(
            UIAlertAction(
                title: buttonTitle,
                style: .default,
                handler: { _ in
                    callback()
                }
            )
        )
        return self
    }
    
    func build() -> UIAlertController {
        return alertVC
    }
}

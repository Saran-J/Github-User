import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        routeToUserList()
    }
    
    func routeToUserList() {
        if let userListVC = UserListViewController.initFromStoryboard() {
            self.navigationController?.pushViewController(userListVC, animated: false)
        }
    }
}

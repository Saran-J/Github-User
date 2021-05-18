import UIKit

protocol UserListDisplayLogic: class {
    func displayUserList(viewModel: UserList.FetchUserList.ViewModel)
    func displaySearchUser(viewModel: UserList.SearchUser.ViewModel)
}

class UserListViewController: UIViewController {
    var interactor: UserListBusinessLogic?
    var router: (NSObjectProtocol & UserListRoutingLogic & UserListDataPassing)?
    var userListDataSource: [UserListObject] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    static func initFromStoryboard() -> UserListViewController? {
        return UIStoryboard(name: "UserList", bundle: nil).instantiateInitialViewController() as? UserListViewController
    }
    
    // MARK: Object lifecycle
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    private func setup() {
        let viewController = self
        let interactor = UserListInteractor()
        let presenter = UserListPresenter()
        let router = UserListRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    // MARK: Routing
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let scene = segue.identifier {
            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: segue)
            }
        }
    }
    
    // MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension UserListViewController: UserListDisplayLogic {
    func displayUserList(viewModel: UserList.FetchUserList.ViewModel) {
        userListDataSource.append(contentsOf: viewModel.userListDisplay)
        tableView.reloadData()
    }
    
    func displaySearchUser(viewModel: UserList.SearchUser.ViewModel) {
        userListDataSource.append(contentsOf: viewModel.userListDisplay)
        tableView.reloadData()
    }
}

extension UserListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userListDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell") as? UserCell else {
            return UITableViewCell()
        }
        cell.nameLabel.text = userListDataSource[indexPath.row].name
        cell.urlLabel.text = userListDataSource[indexPath.row].url
        cell.urlLabel.sizeToFit()
        cell.downloadImage(imageUrl: userListDataSource[indexPath.row].avatarImageUrl)
        return cell
    }
}

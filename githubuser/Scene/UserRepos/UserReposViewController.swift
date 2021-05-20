import UIKit

protocol UserReposDisplayLogic: class {
    func displayUserRepository(viewModel: UserRepos.FetchUserRepository.ViewModel)
}

class UserReposViewController: UIViewController {
    var interactor: UserReposBusinessLogic?
    var router: (NSObjectProtocol & UserReposRoutingLogic & UserReposDataPassing)?
    var userRepositoryData: RepositoryDetail?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerView: RepoHeaderView!
    
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
        let interactor = UserReposInteractor()
        let presenter = UserReposPresenter()
        let router = UserReposRouter()
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

extension UserReposViewController: UserReposDisplayLogic {
    func displayUserRepository(viewModel: UserRepos.FetchUserRepository.ViewModel) {
        userRepositoryData = viewModel.repositoryObject
        headerView.setupData(
            title: toString(userRepositoryData?.name),
            url: toString(userRepositoryData?.url),
            image: toString(userRepositoryData?.avatarImageUrl)
        )
        tableView.reloadData()
    }
}

extension UserReposViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toInt(userRepositoryData?.repository.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: "repoCell") as? RepoCell,
            let repoObject = userRepositoryData?.repository[indexPath.row]
        else {
            return UITableViewCell()
        }
        cell.titleLabel.text = repoObject.title
        cell.detailLabel.text = repoObject.detail
        cell.languageLabel.text = repoObject.language
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return self.headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return RepoHeaderView.headerHeight
    }
}

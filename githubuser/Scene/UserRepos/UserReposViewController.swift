import UIKit
import RxSwift
import RxCocoa

protocol UserReposDisplayLogic: class {
    func displayUserRepository(viewModel: UserRepos.FetchUserRepository.ViewModel)
}

class UserReposViewController: UIViewController {
    var interactor: UserReposBusinessLogic?
    var router: (NSObjectProtocol & UserReposRoutingLogic & UserReposDataPassing)?
    var userRepositoryData: [RepositoryObject] = []
    var disposeBag = DisposeBag()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerView: RepoHeaderView!
    
    var refreshControl = UIRefreshControl()
    var isLastPage = false
    
    static func initFromStoryboard() -> UserReposViewController? {
        return UIStoryboard(name: "UserRepos", bundle: nil)
            .instantiateInitialViewController() as? UserReposViewController
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
        setupTableView()
        fetchRepo(shouldReload: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func setupTableView() {
        refreshControl.attributedTitle = NSAttributedString(string: "Refresh")
        refreshControl.rx.controlEvent(.valueChanged)
            .bind { [weak self] _ in
                self?.fetchRepo(shouldReload: true)
            }
        .disposed(by: disposeBag)
        tableView.addSubview(refreshControl)
    }
    
    func fetchRepo(shouldReload: Bool) {
        interactor?.fetchUserRepository(
            request: UserRepos.FetchUserRepository.Request(shouldReload: shouldReload))
    }
}

extension UserReposViewController: UserReposDisplayLogic {
    func displayUserRepository(viewModel: UserRepos.FetchUserRepository.ViewModel) {
        if viewModel.shouldReload { userRepositoryData = [] }
        userRepositoryData.append(contentsOf: viewModel.repositoryObject.repository)
        endRefreshing()
        isLastPage = viewModel.isLastPage
        headerView.setupData(
            title: toString(viewModel.repositoryObject.name),
            url: toString(viewModel.repositoryObject.url),
            image: toString(viewModel.repositoryObject.avatarImageUrl)
        )
        tableView.reloadData()
    }
    
    func endRefreshing() {
        if refreshControl.isRefreshing {
            refreshControl.endRefreshing()
        }
    }
}

extension UserReposViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userRepositoryData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: "RepoCell") as? RepoCell
        else {
            return UITableViewCell()
        }
        let repoObject = userRepositoryData[indexPath.row]
        cell.titleLabel.text = repoObject.title
        cell.detailLabel.text = repoObject.detail
        cell.languageLabel.text = repoObject.language
        
        if indexPath.row == userRepositoryData.count - 1 && !isLastPage {
            fetchRepo(shouldReload: false)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return self.headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return RepoHeaderView.headerHeight
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return RepoCell.rowHeight
    }
}

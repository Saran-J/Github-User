import UIKit
import RxSwift
import RxCocoa

protocol UserListDisplayLogic: class {
    func displayUserList(viewModel: UserList.QueryUser.ViewModel)
    func displayError(title: String, message: String)
}

typealias SortFilter = (sort: SortData, filter: FilterData)

class UserListViewController: BaseViewController {
    var interactor: UserListBusinessLogic?
    var router: (NSObjectProtocol & UserListRoutingLogic & UserListDataPassing)?
    var userListDataSource: [UserListObject] = []
    var disposeBag = DisposeBag()
    let worker = FavoriteWorker()
    
    let sortFilterSubject = BehaviorSubject<SortFilter>(
        value: (sort: .bestMatch, filter: .noFilter))
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchTextfield: UITextField!
    @IBOutlet weak var filterButton: UIButton!
    
    var refreshControl = UIRefreshControl()
    var isLastPage = false
    var isFilterOrSort = false {
        didSet {
            let imageName = isFilterOrSort ? "filterActive" : "filter"
            filterButton.setImage(UIImage(named: imageName), for: .normal)
        }
    }
    var sort: SortData = .bestMatch
    var filter: FilterData = .noFilter
    
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
        bindingSearchTextfield()
        setupTableView()
        searchUserList(keyword: "", shouldReload: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func searchUserList(keyword: String, shouldReload: Bool) {
        let request = UserList.QueryUser.Request(
            keyword: keyword,
            shouldReload: shouldReload)
        interactor?.queryUserList(request: request)
    }
    
    func setupTableView() {
        refreshControl.attributedTitle = NSAttributedString(string: "Refresh")
        refreshControl.rx.controlEvent(.valueChanged)
            .bind { [weak self] _ in
                self?.fetchData(shouldReload: true)
            }
        .disposed(by: disposeBag)
        tableView.addSubview(refreshControl)
    }
    
    func bindingSearchTextfield() {
        searchTextfield.rx.controlEvent(.editingChanged)
            .map { [weak self] () -> String in
                return self?.searchTextfield.text ?? ""
            }
            .distinctUntilChanged()
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .bind { [weak self] keyword in
                self?.searchUserList(
                    keyword: keyword,
                    shouldReload: true)
            }
            .disposed(by: disposeBag)
    }
    
    @IBAction func onTapFilterButton() {
        guard let filterVC = FilterViewController.initFromStoryboard(
            sort: sort,
            filter: filter
        ) else {
            return
        }
        filterVC.delegate = self
        present(filterVC, animated: true, completion: nil)
    }
}

extension UserListViewController: FilterViewDelegate {
    func didFinishSortAndFilter(sort: SortData, filter: FilterData) {
        self.sort = sort
        self.filter = filter
        isFilterOrSort = !(sort == .bestMatch && filter == .noFilter)
    }
}

extension UserListViewController: UserListDisplayLogic {
    func displayUserList(viewModel: UserList.QueryUser.ViewModel) {
        if viewModel.shouldReload { userListDataSource = [] }
        userListDataSource.append(contentsOf: viewModel.userListDisplay)
        endRefreshing()
        self.isLastPage = viewModel.isLastPage
        self.tableView.reloadData()
        DispatchQueue.main.asyncAfter(deadline: .now()) { [weak self] in
            if viewModel.shouldReload {
                self?.tableView.setContentOffset(.zero, animated: true)
            }
        }
    }
    
    func displayError(title: String, message: String) {
        displayMessage(title: title, message: message)
    }
    
    func endRefreshing() {
        if refreshControl.isRefreshing {
            refreshControl.endRefreshing()
        }
    }
    
    func fetchData(shouldReload: Bool) {
        let keyword = toString(self.searchTextfield.text)
        self.searchUserList(keyword: keyword, shouldReload: shouldReload)
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
        cell.isFavorite = userListDataSource[indexPath.row].isFavorite
         
        cell.onFavorite = { [weak self] isFavorite in
            let userId = self?.userListDataSource[indexPath.row].id
            self?.updateFavorite(userId: userId, favorite: isFavorite)
        }
        cell.downloadImage(imageUrl: userListDataSource[indexPath.row].avatarImageUrl)
        
        if indexPath.row == userListDataSource.count - 1 && !isLastPage {
            fetchData(shouldReload: false)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let id = Int(userListDataSource[indexPath.row].id)
        print(id)
        router?.routeToUserRepositoryList(id: id)
    }
    
    func updateFavorite(userId: Int64?, favorite: Bool) {
        if let userId = userId {
            let request = UserList.FavoriteUser.Request(
                userId: userId,
                favorite: favorite)
            interactor?.favoriteUser(request: request)
            userListDataSource.first { $0.id == userId }?.isFavorite = favorite
        }
    }
}

extension UserListViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

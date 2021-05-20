import UIKit

protocol UserReposDisplayLogic: class {
    func displayUserRepository(viewModel: UserRepos.FetchUserRepository.ViewModel)
}

class UserReposViewController: UIViewController {
    var interactor: UserReposBusinessLogic?
    var router: (NSObjectProtocol & UserReposRoutingLogic & UserReposDataPassing)?
    
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
    }
}

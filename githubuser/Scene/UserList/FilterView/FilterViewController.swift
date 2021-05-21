import UIKit
import SkyFloatingLabelTextField

enum Order: String {
    case asc
    case desc
}

enum SortData: String {
    case bestMatch = "Best match"
    case mostFollowers = "Most followers"
    case fewestFollowers = "Fewest ffollowers"
    case mostRecentlyJoined = "Most recently joined"
    case leastRecentlyJoined = "Least recently joned"
    case mostRepository = "Most repositories"
    case fewestRepository = "Fewest repositories"
    
    func queryString() -> String {
        switch self {
        case .bestMatch:
            return ""
        case .mostFollowers, .fewestFollowers:
            return "followers"
        case .mostRecentlyJoined, .leastRecentlyJoined:
            return "joined"
        case .mostRepository, .fewestRepository:
            return "repositories"
        }
    }
    
    func orderQueryString() -> Order {
        switch self {
        case
            .bestMatch,
            .fewestFollowers,
            .leastRecentlyJoined,
            .fewestRepository:
            return .desc
        case
            .mostFollowers,
            .mostRecentlyJoined,
            .mostRepository:
            return .asc
        }
    }
}

enum FilterData: String {
    case noFilter = "No filter"
    case favorite = "Only favorite"
}

struct SearchOptionData: Equatable {
    var keyword: String
    var sort: SortData
    var filter: FilterData
}

protocol FilterViewDelegate: class {
    func didFinishSortAndFilter(searchData: SearchOptionData)
}

class FilterViewController: UIViewController {
    let cellIdentifier = "sortAndFilterCell"
    let sortList: [SortData] = [
        .bestMatch,
        .mostFollowers,
        .fewestFollowers,
        .mostRecentlyJoined,
        .leastRecentlyJoined,
        .mostRepository,
        .fewestRepository
    ]
    
    let filterList: [FilterData] = [
        .noFilter,
        .favorite
    ]
    
    var currentSort: SortData = .bestMatch {
        didSet {
            tableView?.reloadData()
        }
    }
    var currentFilter: FilterData = .noFilter {
        didSet {
            tableView?.reloadData()
        }
    }
    
    var currentKeyword = ""
    
    weak var delegate: FilterViewDelegate?
    @IBOutlet weak var tableView: UITableView?
    @IBOutlet weak var searchTextfield: SkyFloatingLabelTextField!
    
    static func initFromStoryboard(keyword: String, sort: SortData, filter: FilterData) -> FilterViewController? {
        let filterVC = UIStoryboard(
            name: "UserList",
            bundle: nil
        ).instantiateViewController(
            withIdentifier: "FilterVC"
        ) as? FilterViewController
        filterVC?.currentKeyword = keyword
        filterVC?.currentSort = sort
        filterVC?.currentFilter = filter
        return filterVC
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView?.reloadData()
        searchTextfield.text = currentKeyword
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onTapDone() {
        guard !toString(searchTextfield.text).isEmpty || currentSort == .bestMatch else {
            searchTextfield.errorMessage = "Please type keyword first!"
            return
        }
        searchTextfield.errorMessage = ""
        let searchData = SearchOptionData(
            keyword: toString(searchTextfield.text),
            sort: currentSort,
            filter: currentFilter
        )
        delegate?.didFinishSortAndFilter(searchData: searchData)
        dismiss(animated: true, completion: nil)
    }
}

extension FilterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension FilterViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return self.sortList.count
        case 1:
            return self.filterList.count
        default: return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = {
            if let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) {
                return cell
            }
            return UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
        }()
        
        switch indexPath.section {
        case 0:
            let sortDisplay = self.sortList[indexPath.row]
            cell.textLabel?.text = sortDisplay.rawValue
            cell.accessoryType = (currentSort == sortDisplay) ? .checkmark : .none
        case 1:
            let filterDisplay = self.filterList[indexPath.row]
            cell.textLabel?.text = filterDisplay.rawValue
            cell.accessoryType = (currentFilter == filterDisplay) ? .checkmark : .none
        default: break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            currentSort = self.sortList[indexPath.row]
        case 1:
            currentFilter = self.filterList[indexPath.row]
        default: break
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Sort Option"
        case 1:
            return "Filter Option"
        default: return ""
        }
    }
}

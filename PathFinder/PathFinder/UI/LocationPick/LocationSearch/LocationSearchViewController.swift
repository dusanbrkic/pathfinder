import UIKit
import MapKit

class LocationSearchViewController: BaseViewController {
    static let cellHeight: CGFloat = 45
    
    var searchController: UISearchController?
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: view.frame.size.width - 2 * Dimensions.Inset.medium, height: Self.cellHeight)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(LocationSearchCollectionViewCell.self, forCellWithReuseIdentifier: LocationSearchCollectionViewCell.getReuseIdentifier())
        collectionView.contentInset = UIEdgeInsets(top: Dimensions.Inset.small, left: Dimensions.Inset.medium, bottom: Dimensions.Inset.small, right: Dimensions.Inset.medium)
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    var region: MKCoordinateRegion?
    weak var searchDelegate: HandleMapSearch?
    var matchingItems: [MKMapItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    private func setupViews() {
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.right.bottom.equalToSuperview()
        }
    }
}


extension LocationSearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        self.searchController = searchController
        guard let region = region,
              let searchBarText = searchController.searchBar.text else { return }
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchBarText
        request.region = region
        let search = MKLocalSearch(request: request)
        search.start { response, _ in
            guard let response = response else {
                return
            }
            self.matchingItems = response.mapItems
            self.collectionView.reloadData()
        }
    }
}

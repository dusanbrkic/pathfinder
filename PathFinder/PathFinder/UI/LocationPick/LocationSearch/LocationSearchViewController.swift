import UIKit
import MapKit

class LocationSearchViewController: BaseViewController {
    static let cellHeight: CGFloat = 45
    
    let viewModel = DIManager.instance.resolve(LocationSearchViewModel.self)
    
    var region: MKCoordinateRegion?
    var matchingItems: [MKMapItem] = []
    var searchController: UISearchController?
    weak var searchDelegate: HandleMapSearch?
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupObservers()
    }
    
    private func setupViews() {
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    private func setupObservers() {
        viewModel.$state
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink { [weak self] state in
                switch state {
                case is LocationSearchState.Idle:
                    let response = (state as? LocationSearchState.Idle)?.response
                    self?.updateViews(response: response)
                default:
                    break
                }
            }.store(in: &cancellableSet)
    }
    
    private func updateViews(response: MKLocalSearch.Response?) {
        guard let response = response else {
            return
        }
        self.matchingItems = response.mapItems
        self.collectionView.reloadData()
    }
}


extension LocationSearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        self.searchController = searchController
        guard let region = region, let searchBarText = searchController.searchBar.text else { return }
        viewModel.searchPlaces(query: searchBarText, region: region)
    }
}

import UIKit
import SnapKit
import MapKit

class LocationPickViewController: BaseViewController {
    static let smallCoordinatesDelta = 0.05
    static let largeCoordinatesDelta = 0.2
    
    private let viewModel = DIManager.instance.resolve(LocationPickViewModel.self)
    
    var selectedPin: MKPlacemark? = nil
    private var isMapCenterSet = false
    
    lazy var mapView: MKMapView = {
        let view = MKMapView(frame: .zero)
        view.showsUserLocation = true
        return view
    }()
    
    lazy var chooseLocationButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setTitle(Localization.General.chooseThisLocation, for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.isHidden = true
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupObservers()
        setupSearchBar()
        setupActions()
        setupGestures()
        
        viewModel.startUpdatingUserCoordinates()
    }
    
    private func setupViews() {
        view.addSubview(mapView)
        view.addSubview(chooseLocationButton)
        
        chooseLocationButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        mapView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(chooseLocationButton.snp.top).offset(-Dimensions.Inset.large)
        }
    }
    
    private func setupObservers() {
        viewModel.$userCoordinates
            .receive(on: DispatchQueue.main)
            .sink { [weak self] coordinates in
                guard let coordinates, self?.isMapCenterSet == false else { return }
                self?.setMapCenter(with: coordinates)
            }.store(in: &cancellableSet)
    }
    
    private func setMapCenter(with coordinates: Location.Coordinates) {
        let mapCoordinates = CLLocationCoordinate2D(latitude: coordinates.latitude, longitude: coordinates.longitude)
        let span = MKCoordinateSpan(latitudeDelta: Self.largeCoordinatesDelta, longitudeDelta: Self.largeCoordinatesDelta)
        let region = MKCoordinateRegion(center: mapCoordinates, span: span)
        mapView.setRegion(region, animated: true)
        selectLocation(on: MKPlacemark(coordinate: mapCoordinates))
        isMapCenterSet = true
    }
    
    private func setupSearchBar() {
        let locationSearchViewController = LocationSearchViewController()
        locationSearchViewController.region = mapView.region
        locationSearchViewController.searchDelegate = self
        navigationItem.searchController = UISearchController(searchResultsController: locationSearchViewController)
        
        let searchController = navigationItem.searchController
        searchController?.searchResultsUpdater = locationSearchViewController
        searchController?.obscuresBackgroundDuringPresentation = true
        searchController?.automaticallyShowsSearchResultsController = true
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    private func setupActions() {
        chooseLocationButton.addTarget(self, action: #selector(onLocationChoose), for: .touchUpInside)
    }
    
    @objc private func onLocationChoose() {
        if let selectedPin {
            viewModel.chooseLocation(with: Location.Coordinates(latitude: selectedPin.coordinate.latitude, longitude: selectedPin.coordinate.longitude))
            navigationController?.popViewController(animated: true)
        }
    }
    
    private func setupGestures() {
        mapView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onMapViewTap(gestureRecognizer:))))
    }
    
    @objc private func onMapViewTap(gestureRecognizer: UITapGestureRecognizer) {
        let locationCoordinates = mapView.convert(gestureRecognizer.location(in: mapView), toCoordinateFrom: mapView)
        selectLocation(on: MKPlacemark(coordinate: locationCoordinates))
        
    }
    
    func selectLocation(on placemark: MKPlacemark, fromSearch isFromSearch: Bool = false) {
        selectedPin = placemark
        mapView.removeAnnotations(mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        if let city = placemark.locality,
           let state = placemark.administrativeArea {
            annotation.subtitle = "\(city) \(state)"
        }
        mapView.addAnnotation(annotation)
        
        if isFromSearch {
            let span = MKCoordinateSpan(latitudeDelta: Self.smallCoordinatesDelta, longitudeDelta: Self.smallCoordinatesDelta)
            let region = MKCoordinateRegion(center: placemark.coordinate, span: span)
            mapView.setRegion(region, animated: true)
        }
        
        chooseLocationButton.isHidden = false
    }
}

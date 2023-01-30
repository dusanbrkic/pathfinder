import UIKit
import MapKit
import SnapKit

class WelcomeViewController: BaseViewController {
    private let viewModel = DIManager.instance.resolve(WelcomeViewModel.self)
    
    var chosenLocation: Location.Coordinates?
    
    private lazy var tcomLogoImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        let image = UIImage(named: Images.tcomLogo)
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var tcomLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = Localization.General.tcom
        label.font = UIFont(name: "Arial-BoldMT", size: 22)
        return label
    }()
    
    private lazy var welcomeTo: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "Welcome to Path Finder"
        label.font = UIFont(name: "Arial-BoldMT", size: 32)
        return label
    }()
    
    private lazy var createANewLocationButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setTitle("Choose on map", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        return button
    }()
    
    private lazy var openInMaps: UIButton = {
        let button = UIButton(frame: .zero)
        button.setTitle("Open in maps", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.isHidden = true
        return button
    }()
    
    private lazy var compass: UIButton = {
        let button = UIButton(frame: .zero)
        button.setTitle("Compass", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.isHidden = true
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupActions()
        setupObservers()
    }
    
    private func setupViews() {
        view.addSubview(tcomLogoImageView)
        view.addSubview(tcomLabel)
        view.addSubview(welcomeTo)
        view.addSubview(createANewLocationButton)
        view.addSubview(openInMaps)
        view.addSubview(compass)
        
        tcomLogoImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(200)
        }
        
        tcomLabel.snp.makeConstraints { make in
            make.top.equalTo(tcomLogoImageView.snp.bottom).offset(15)
            make.centerX.equalToSuperview()
        }
        
        welcomeTo.snp.makeConstraints { make in
            make.top.equalTo(tcomLabel.snp.bottom).offset(32)
            make.centerX.equalToSuperview()
        }
        
        createANewLocationButton.snp.makeConstraints { make in
            make.top.equalTo(welcomeTo.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        
        openInMaps.snp.makeConstraints { make in
            make.top.equalTo(createANewLocationButton.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        
        compass.snp.makeConstraints { make in
            make.top.equalTo(openInMaps.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
    }
    
    private func setupActions() {
        createANewLocationButton.addTarget(self, action: #selector(onCreateLocationAction), for: .touchUpInside)
        openInMaps.addTarget(self, action: #selector(openLocationInAppleMaps), for: .touchUpInside)
        compass.addTarget(self, action: #selector(navigateToCompass), for: .touchUpInside)
    }
    
    @objc func onCreateLocationAction(sender: UIButton) {
        navigationController?.pushViewController(LocationPickViewController(), animated: true)
    }
    
    @objc func openLocationInAppleMaps() {
        if let chosenLocation {
            let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: chosenLocation.latitude, longitude: chosenLocation.longitude), addressDictionary: nil))
            mapItem.name = "Destination"
            mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
        }
    }
    
    @objc func navigateToCompass() {
        guard let chosenLocation else { return }
        navigationController?.pushViewController(CompassViewController(with: chosenLocation), animated: true)
    }
    
    private func setupObservers() {
        viewModel.$state.receive(on: DispatchQueue.main)
            .sink { [weak self] welcomeState in
                switch welcomeState {
                case is WelcomeState.ChooseLocation:
                    self?.setupChooseLocation()
                case is WelcomeState.LocationChosen:
                    let location = (welcomeState as? WelcomeState.LocationChosen)?.location
                    self?.setupLocationChosen(with: location)
                default:
                    break
                }
            }.store(in: &cancellableSet)
    }
    
    private func setupChooseLocation() {
        openInMaps.isHidden = true
        compass.isHidden = true
    }
    
    private func setupLocationChosen(with location: Location.Coordinates?) {
        chosenLocation = location
        
        openInMaps.isHidden = false
        compass.isHidden = false
    }
}

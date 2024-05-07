import UIKit
import MapKit
import SnapKit

class WelcomeViewController: BaseViewController {
    private let viewModel = DIManager.instance.resolve(WelcomeViewModel.self)
    
    var chosenLocation: Location.Coordinates?
    
    private lazy var welcomeTo: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = Localization.General.welcomeTo
        label.font = UIFont(name: "Arial-BoldMT", size: Dimensions.Fonts.medium)
        return label
    }()
    
    private lazy var pathFinder: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = Localization.General.pathFinder.uppercased()
        label.font = UIFont(name: "Arial-BoldMT", size: Dimensions.Fonts.large)
        return label
    }()
    
    private lazy var createANewLocationButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setTitle(Localization.General.chooseANewLocation, for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        return button
    }()
    
    private lazy var openInMaps: UIButton = {
        let button = UIButton(frame: .zero)
        button.setTitle(Localization.General.openInAppleMaps, for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.isHidden = true
        return button
    }()
    
    private lazy var compass: UIButton = {
        let button = UIButton(frame: .zero)
        button.setTitle(Localization.General.compass, for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
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
        view.addSubview(welcomeTo)
        view.addSubview(pathFinder)
        view.addSubview(createANewLocationButton)
        view.addSubview(openInMaps)
        view.addSubview(compass)
        
        welcomeTo.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(Dimensions.Inset.large)
            make.left.equalToSuperview().offset(Dimensions.Inset.medium)
            make.right.equalToSuperview().offset(-Dimensions.Inset.medium)
        }
        
        pathFinder.snp.makeConstraints { make in
            make.top.equalTo(welcomeTo.snp.bottom).offset(Dimensions.Inset.small)
            make.left.equalToSuperview().offset(Dimensions.Inset.medium)
            make.right.equalToSuperview().offset(-Dimensions.Inset.medium)
        }
        
        createANewLocationButton.snp.makeConstraints { make in
            make.bottom.equalTo(openInMaps.snp.top).offset(-Dimensions.Inset.medium)
            make.centerX.equalToSuperview()
        }
        
        openInMaps.snp.makeConstraints { make in
            make.bottom.equalTo(compass.snp.top).offset(-Dimensions.Inset.medium)
            make.centerX.equalToSuperview()
        }
        
        compass.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide)
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
            mapItem.name = Localization.General.destination
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

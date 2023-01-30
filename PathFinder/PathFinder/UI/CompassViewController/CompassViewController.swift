import UIKit
import Combine

class CompassViewController: BaseViewController {
    private let viewModel = DIManager.instance.resolve(CompassViewModel.self)
    
    private var pickedLocationCoordinates: Location.Coordinates?
    private var currentLocationCoordinates: Location.Coordinates?
    private var locationTrueNorthHeading: Location.Heading?
    
    init(with pickedLocationCoordinates: Location.Coordinates) {
        self.pickedLocationCoordinates = pickedLocationCoordinates
        super.init()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private lazy var compassView: UIImageView = {
        let image = UIImage(named: Images.compassArrow)
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        return imageView
    }()
    
    private lazy var distanceLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont(name: "Arial-BoldMT", size: 22)
        label.textAlignment = .center
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupObservers()
        
        if let pickedLocationCoordinates {
            viewModel.startUpdatingLocationData(with: pickedLocationCoordinates)
        }
    }
    
    private func setupViews() {
        view.addSubview(compassView)
        view.addSubview(distanceLabel)
        
        compassView.snp.makeConstraints { make in
            make.width.equalTo(200)
            make.center.equalToSuperview()
        }
        
        distanceLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(25)
            make.right.equalToSuperview().offset(-25)
            make.top.equalTo(compassView.snp.bottom).offset(15)
        }
    }
    
    private func setupObservers() {
        viewModel.$locationData
            .receive(on: DispatchQueue.main)
            .sink { [weak self] locationData in
                guard let locationData else { return }
                self?.updateCompass(with: locationData)
            }.store(in: &cancellableSet)
    }
    
    private func updateCompass(with locationData: LocationData) {
        distanceLabel.text = "\(locationData.distanceInMeters.rounded()) m"
        
        UIView.animate(withDuration: 0.5) {
            self.compassView.transform = CGAffineTransform(rotationAngle: -locationData.trueNorthHeading + locationData.pickedLocationHeading)
        }
    }
}

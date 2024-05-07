import UIKit
import MapKit

class LocationSearchCollectionViewCell: UICollectionViewCell {
    private lazy var locationNameLabel: UILabel = {
        UILabel(frame: .zero)
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func initViews() {
        addSubview(locationNameLabel)
        
        locationNameLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func setup(with mapItem: MKMapItem) {
        locationNameLabel.text = "\(mapItem.name ?? "")"
        
        if let city = mapItem.placemark.locality {
            locationNameLabel.text?.append(", \(city)")
        }
        
        if let country = mapItem.placemark.country {
            locationNameLabel.text?.append(", \(country)")
        }
    }
}

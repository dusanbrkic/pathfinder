import CoreLocation
import Combine

class LocationService: NSObject, LocationServiceDelegate {
    private let locationManager = CLLocationManager()
    
    var currentLocation: AnyPublisher<Location.Coordinates, Never> { $currentLocationValue.eraseToAnyPublisher() }
    var currentHeading: AnyPublisher<Location.Heading, Never> { $currentHeadingValue.eraseToAnyPublisher() }
    
    @Published var currentLocationValue: Location.Coordinates
    @Published var currentHeadingValue: Location.Heading
    
    override init() {
        currentLocationValue = Location.Coordinates(latitude: 90.0, longitude: 135.0)
        currentHeadingValue = Location.Heading(0.0)
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.startUpdatingHeading()
        locationManager.startUpdatingLocation()
    }
    
    func getDistance(from startCoordinates: Location.Coordinates, to finishCoordinates: Location.Coordinates) -> Double {
        CLLocation(latitude: startCoordinates.latitude, longitude: startCoordinates.longitude).distance(from: CLLocation(latitude: finishCoordinates.latitude, longitude: finishCoordinates.longitude))
    }
    
}

extension LocationService: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            currentLocationValue = Location.Coordinates(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        currentHeadingValue = Location.Heading(newHeading.trueHeading.toRadians)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {}
}

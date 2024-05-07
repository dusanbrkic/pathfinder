import Foundation
import Combine

protocol GetLocationDataUseCaseDelegate {
    func execute(with pickedLocationCoordinates: Location.Coordinates) -> AnyPublisher<LocationData?, Never>
}

class GetLocationDataUseCase: GetLocationDataUseCaseDelegate {
    private let locationService: LocationServiceDelegate
    
    init(locationService: LocationServiceDelegate) {
        self.locationService = locationService
    }
    
    func execute(with pickedLocationCoordinates: Location.Coordinates) -> AnyPublisher<LocationData?, Never> {
        return Publishers
            .CombineLatest(locationService.currentLocation, locationService.currentHeading)
            .map { [weak self] currentLocationCoordinates, trueNorthHeading in
                guard let pickedLocationHeading = self?.getPickedLocationHeading(from: currentLocationCoordinates, to: pickedLocationCoordinates), let distance = self?.locationService.getDistance(from: currentLocationCoordinates, to: pickedLocationCoordinates) else { return nil }
                
                return LocationData(currentLocationCoordinates: currentLocationCoordinates, trueNorthHeading: trueNorthHeading, pickedLocationCoordinates: pickedLocationCoordinates, pickedLocationHeading: pickedLocationHeading, distanceInMeters: distance)
            }.eraseToAnyPublisher()
    }
    
    private func getPickedLocationHeading(from currentCoordinates: Location.Coordinates, to pickedCoordinates: Location.Coordinates) -> Location.Heading {
        let lat1 = currentCoordinates.latitude.toRadians
        let lon1 = currentCoordinates.longitude.toRadians
        
        let lat2 = pickedCoordinates.latitude.toRadians
        let lon2 = pickedCoordinates.longitude.toRadians
        
        let dLon = lon2 - lon1
        
        let y = sin(dLon) * cos(lat2)
        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon)
        
        let bearing = atan2(y, x)
        
        return Location.Heading(bearing)
    }
}

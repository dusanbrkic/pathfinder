import Foundation
import Combine

protocol GetUserCoordinatesUseCaseDelegate {
    func execute() -> AnyPublisher<Location.Coordinates, Never>
}

class GetUserCoordinatesUseCase: GetUserCoordinatesUseCaseDelegate {
    private let locationService: LocationServiceDelegate
    
    init(locationService: LocationServiceDelegate) {
        self.locationService = locationService
    }
    
    func execute() -> AnyPublisher<Location.Coordinates, Never> {
        locationService.currentLocation.eraseToAnyPublisher()
    }
}

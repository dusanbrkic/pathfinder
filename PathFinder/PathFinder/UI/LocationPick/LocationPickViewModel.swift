import Foundation
import Combine

class LocationPickViewModel: BaseViewModel {
    private let getUserCoordinatesUseCase: GetUserCoordinatesUseCaseDelegate
    private let notificationService: NotificationCenter
    
    @Published var userCoordinates: Location.Coordinates?
    
    init(getUserCoordinatesUseCase: GetUserCoordinatesUseCaseDelegate, notificationService: NotificationCenter) {
        self.getUserCoordinatesUseCase = getUserCoordinatesUseCase
        self.notificationService = notificationService
        super.init()
    }
    
    func startUpdatingUserCoordinates() {
        getUserCoordinatesUseCase.execute()
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] coordinates in
                self?.userCoordinates = coordinates
            }.store(in: &cancellableSet)
    }
    
    func chooseLocation(with locationCoordinates: Location.Coordinates) {
        notificationService.post(name: .locationPicked, object: Location.Coordinates(latitude: locationCoordinates.latitude, longitude: locationCoordinates.longitude))
    }
}

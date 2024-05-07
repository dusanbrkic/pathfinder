import Foundation
import Combine

class CompassViewModel: BaseViewModel {
    private let getLocationDataUseCase: GetLocationDataUseCaseDelegate
    
    @Published var locationData: LocationData?

    init(getLocationDataUseCase: GetLocationDataUseCaseDelegate) {
        self.getLocationDataUseCase = getLocationDataUseCase
        super.init()
    }
    
    func startUpdatingLocationData(with pickedCoordinates: Location.Coordinates) {
        getLocationDataUseCase.execute(with: pickedCoordinates)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] locationData in
                self?.locationData = locationData
            }.store(in: &cancellableSet)
    }
}

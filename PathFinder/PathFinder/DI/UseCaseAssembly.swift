import Foundation
import Swinject

class GetLocationDataUseCaseAssembly: Assembly {
    func assemble(container: Swinject.Container) {
        container.register(GetLocationDataUseCaseDelegate.self) { resolver in
            let locationService = resolver.resolve(LocationServiceDelegate.self)!
            return GetLocationDataUseCase(locationService: locationService)
        }
    }
}

class GetUserCoordinatesUseCaseAssembly: Assembly {
    func assemble(container: Swinject.Container) {
        container.register(GetUserCoordinatesUseCaseDelegate.self) { resolver in
            let locationService = resolver.resolve(LocationServiceDelegate.self)!
            return GetUserCoordinatesUseCase(locationService: locationService)
        }
    }
}

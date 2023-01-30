import Swinject
import Foundation

class WelcomeViewModelAssembly: Assembly {
    func assemble(container: Swinject.Container) {
        container.register(WelcomeViewModel.self) { resolver in
            let notificationService = NotificationCenter.default
            return WelcomeViewModel(notificationService: notificationService)
        }
    }
}

class LocationPickViewModelAssembly: Assembly {
    func assemble(container: Swinject.Container) {
        container.register(LocationPickViewModel.self) { resolver in
            let getUserCoordinatesUseCase = resolver.resolve(GetUserCoordinatesUseCaseDelegate.self)!
            let notificationService = NotificationCenter.default
            return LocationPickViewModel(getUserCoordinatesUseCase: getUserCoordinatesUseCase, notificationService: notificationService)
        }
    }
}

class LocationSearchViewModelAssembly: Assembly {
    func assemble(container: Swinject.Container) {
        container.register(LocationSearchViewModel.self) { resolver in
            return LocationSearchViewModel()
        }
    }
}

class CompassViewModelAssembly: Assembly {
    func assemble(container: Swinject.Container) {
        container.register(CompassViewModel.self) { resolver in
            let getLocationDataUseCase = resolver.resolve(GetLocationDataUseCaseDelegate.self)!
            return CompassViewModel(getLocationDataUseCase: getLocationDataUseCase)
        }
    }
}

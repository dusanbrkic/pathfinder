import Swinject
import Foundation

class LocationServiceAssembly: Assembly {
    func assemble(container: Swinject.Container) {
        container.register(LocationServiceDelegate.self) { resolver in
            return LocationService()
        }.inObjectScope(.transient)
    }
}

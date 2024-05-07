import Foundation
import Swinject

final class DIManager {
    private let assembler: Assembler
    private let resolver: Resolver
    
    static let instance: DIManager = DIManager()
    
    private init() {
        let container = Container()
        let assembler = Assembler([
            // services
            LocationServiceAssembly(),
            
            // use cases
            GetLocationDataUseCaseAssembly(),
            GetUserCoordinatesUseCaseAssembly(),
            
            // view models
            WelcomeViewModelAssembly(),
            LocationPickViewModelAssembly(),
            LocationSearchViewModelAssembly(),
            CompassViewModelAssembly()
            
        ], container: container)
        
        self.assembler = assembler
        self.resolver = container.synchronize()
    }
    
    func resolve<Service>(_ serviceType: Service.Type) -> Service {
        guard let service = resolver.resolve(serviceType) else { fatalError("Resolving failed") }
        return service
    }
}

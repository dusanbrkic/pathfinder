import Combine

protocol LocationServiceDelegate {
    var currentLocation: AnyPublisher<Location.Coordinates, Never> { get }
    var currentHeading: AnyPublisher<Location.Heading, Never> { get }
    
    func getDistance(from: Location.Coordinates, to: Location.Coordinates) -> Double
}

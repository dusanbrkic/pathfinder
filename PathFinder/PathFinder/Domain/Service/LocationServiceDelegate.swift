import Combine

protocol LocationServiceDelegate {
    var currentLocation: Published<Location.Coordinates>.Publisher { get }
    var currentHeading: Published<Location.Heading>.Publisher { get }
    
    func getDistance(from: Location.Coordinates, to: Location.Coordinates) -> Double
}

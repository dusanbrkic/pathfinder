import Combine

@testable import PathFinderDev

class TestMocks {
    static let locationCoordinates1 = Location.Coordinates(latitude: 135, longitude: 90)
    static let locationCoordinatesPublisher1 = CurrentValueSubject<Location.Coordinates, Never>(locationCoordinates1)
    
    static let locationCoordinates2 = Location.Coordinates(latitude: 22, longitude: 44)
    static let locationCoordinatesPublisher2 = CurrentValueSubject<Location.Coordinates, Never>(locationCoordinates2)
    
    static let trueNorthHeading1 = Location.Heading(0.0)
    static let trueNorthHeadingPublisher1 = CurrentValueSubject<Location.Heading, Never>(trueNorthHeading1)
    
    static let pickedLocationHeading1 = Location.Heading(-2.4)
    static let pickedLocationHeadingPublisher1 = CurrentValueSubject<Location.Heading, Never>(pickedLocationHeading1)
    
    static let distanceInMeters1 = 100.0
    
    static let locationData = LocationData(currentLocationCoordinates: locationCoordinates1, trueNorthHeading: trueNorthHeading1, pickedLocationCoordinates: locationCoordinates2, pickedLocationHeading: pickedLocationHeading1, distanceInMeters: distanceInMeters1)
    static let locationDataPublisher = CurrentValueSubject<LocationData, Never>(locationData)
}

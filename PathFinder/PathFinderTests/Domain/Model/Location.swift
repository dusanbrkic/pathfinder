import Foundation

@testable import PathFinderDev

extension LocationData: Equatable {
    public static func == (lhs: PathFinderDev.LocationData, rhs: PathFinderDev.LocationData) -> Bool {
        lhs.currentLocationCoordinates == rhs.currentLocationCoordinates && lhs.trueNorthHeading == rhs.trueNorthHeading && lhs.pickedLocationCoordinates == rhs.pickedLocationCoordinates && lhs.pickedLocationHeading.rounded() == rhs.pickedLocationHeading.rounded() && lhs.distanceInMeters == rhs.distanceInMeters
    }
}

extension Location.Coordinates: Equatable {
    public static func == (lhs: Location.Coordinates, rhs: Location.Coordinates) -> Bool {
        lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}

struct Location {
    struct Coordinates {
        let latitude: Double
        let longitude: Double
    }
    
    typealias Heading = Double
    typealias Distance = Double
}

struct LocationData {
    let currentLocationCoordinates: Location.Coordinates
    let trueNorthHeading: Location.Heading
    let pickedLocationCoordinates: Location.Coordinates
    let pickedLocationHeading: Location.Heading
    let distanceInMeters: Location.Distance
}

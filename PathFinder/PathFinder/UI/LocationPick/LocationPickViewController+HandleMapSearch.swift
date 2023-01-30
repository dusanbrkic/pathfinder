import MapKit

protocol HandleMapSearch {
    func dropPinZoomIn(placemark: MKPlacemark)
}

extension LocationPickViewController: HandleMapSearch {
    func dropPinZoomIn(placemark: MKPlacemark){
        selectLocation(on: placemark, fromSearch: true)
    }
}

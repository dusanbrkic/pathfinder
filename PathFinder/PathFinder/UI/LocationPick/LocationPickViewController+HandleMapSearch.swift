import MapKit

protocol HandleMapSearch: AnyObject {
    func dropPinZoomIn(placemark: MKPlacemark)
}

extension LocationPickViewController: HandleMapSearch {
    func dropPinZoomIn(placemark: MKPlacemark){
        selectLocation(on: placemark, fromSearch: true)
    }
}

import Foundation
import MapKit

class LocationSearchState {
    class Idle: LocationSearchState {
        let response: MKLocalSearch.Response?
        
        init(response: MKLocalSearch.Response? = nil) {
            self.response = response
        }
    }
    class Searching: LocationSearchState {}
}

class LocationSearchViewModel: BaseViewModel {
    @Published var state: LocationSearchState = LocationSearchState.Idle()
    
    func searchPlaces(query: String, region: MKCoordinateRegion) {
        state = LocationSearchState.Searching()
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        request.region = region
        let search = MKLocalSearch(request: request)
        search.start { [weak self] response, _ in
            self?.state = LocationSearchState.Idle(response: response)
        }
    }
}

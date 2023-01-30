import Combine
import Foundation
import Combine

class WelcomeState {
    class ChooseLocation: WelcomeState {}
    class LocationChosen: WelcomeState {
        var location: Location.Coordinates
        
        init(location: Location.Coordinates) {
            self.location = location
        }
    }
}

class WelcomeViewModel: BaseViewModel {
    @Published var state: WelcomeState = WelcomeState.ChooseLocation()
    
    let notificationService: NotificationCenter
    
    init(notificationService: NotificationCenter) {
        self.notificationService = notificationService
        super.init()
        
        setupNotifications()
    }
    
    func setupNotifications() {
        notificationService.addObserver(self, selector: #selector(onLocationPick(notification:)), name: .locationPicked, object: nil)
    }
    
    @objc func onLocationPick(notification: Notification) {
        if let coordinates = notification.object as? Location.Coordinates {
            state = WelcomeState.LocationChosen(location: coordinates)
        }
    }
}

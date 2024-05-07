import Foundation

struct Localization {
    struct General {
        static let chooseThisLocation = "General.chooseThisLocation".localized
        static let destination = "General.destination".localized
        static let welcomeTo = "General.welcomeTo".localized
        static let pathFinder = "General.pathFinder".localized
        static let chooseANewLocation = "General.chooseANewLocation".localized
        static let openInAppleMaps = "General.openInAppleMaps".localized
        static let compass = "General.compass".localized
    }
}

extension String {
    var localized: String {
        NSLocalizedString(self, comment: "")
    }
}

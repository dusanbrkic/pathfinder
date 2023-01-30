import Foundation

struct Localization {
    struct General {
        static let tcom = "General.tcom".localized
    }
}

extension String {
    var localized: String {
        NSLocalizedString(self, comment: "")
    }
}

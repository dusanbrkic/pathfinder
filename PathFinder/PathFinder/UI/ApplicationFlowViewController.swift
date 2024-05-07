import UIKit

class ApplicationFlowViewController: BaseViewController {
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        navigateToWelcomeScreen()
    }
    
    private func navigateToWelcomeScreen() {
        let welcomeController = WelcomeViewController()
        let rootNavigationController = MainNavigationController(rootViewController: welcomeController)
        view.window?.rootViewController = rootNavigationController
    }
}

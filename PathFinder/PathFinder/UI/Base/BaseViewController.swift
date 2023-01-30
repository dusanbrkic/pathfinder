import UIKit
import Combine

class BaseViewController: UIViewController {
    var cancellableSet: Set<AnyCancellable> = []
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        setupView()
    }
    
    private func setupView() {
        view.backgroundColor = .systemBackground
    }
}

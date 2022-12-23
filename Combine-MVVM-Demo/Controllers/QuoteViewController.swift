import UIKit
import Combine

final class QuoteViewModel {
    // MARK: - Constants
    private let quoteServiceType: QuoteServiceType

    // MARK: - Init
    init(quoteServiceType: QuoteServiceType) {
        self.quoteServiceType = quoteServiceType
    }
}

final class QuoteViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var refreshButton: UIButton!

    // MARK: - Actions
    @IBAction func refreshButtonTapped(_ sender: Any) { }

    // MARK: - Properties

    // MARK: - Constants

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    // MARK: - Setups
}

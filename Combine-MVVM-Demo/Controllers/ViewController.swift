import UIKit
import Combine

final class ViewController: UIViewController {
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

protocol QuoteServiceType {
    func getRandomQuote() -> AnyPublisher<Quote, Error>
}

final class QuoteManager: QuoteServiceType {
    func getRandomQuote() -> AnyPublisher<Quote, Error> {
        <#code#>
    }
}

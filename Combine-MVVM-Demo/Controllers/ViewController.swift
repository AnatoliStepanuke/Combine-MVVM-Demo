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
        guard let url = URL(string: Constants.quoteReference) else {
            return Result<Quote, Error>.failure(QuoteError.resultFailure).publisher.eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: url)
            .catch { error in
                return Fail(error: error).eraseToAnyPublisher()
            }
            .map { $0.data }
            .decode(type: Quote.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}

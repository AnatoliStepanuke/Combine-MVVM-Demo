import UIKit
import Combine

final class QuoteViewModel {
    // MARK: - Enums
    enum Input {
        case viewDidAppear
        case refreshButtonDidTapped
    }
    enum Output {
        case fetchQuoteDidFailed(error: Error)
        case fetchQuoteDidSucceded(quote: Quote)
        case toggleButton(isEnabled: Bool)
    }

    // MARK: - Constants
    private let quoteServiceType: QuoteServiceType
    private let passthroughSubjectOutput: PassthroughSubject<Output, Never> = .init()

    // MARK: - Init
    init(quoteServiceType: QuoteServiceType = QuoteService(networkManager: APIManager())) {
        self.quoteServiceType = quoteServiceType
    }

    // MARK: - API
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        return passthroughSubjectOutput.eraseToAnyPublisher()
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
    private let quoteViewModel = QuoteViewModel()
    private let passthroughSubjectInput: PassthroughSubject<QuoteViewModel.Input, Never> = .init()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        bindSetup()
    }
    // MARK: - Setups
    private func bindSetup() {
        let output = quoteViewModel.transform(input: passthroughSubjectInput.eraseToAnyPublisher())
        output.sink { [weak self] event in
            switch event {
            case .fetchQuoteDidSucceded(let quote): self?.quoteLabel.text = quote.content
            case .fetchQuoteDidFailed(let error): self?.quoteLabel.text = error.localizedDescription
            case .toggleButton(let isEnabled): self?.refreshButton.isEnabled = isEnabled
            }
        }
    }
}

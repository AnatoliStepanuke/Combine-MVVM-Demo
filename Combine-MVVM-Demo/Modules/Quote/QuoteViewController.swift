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

    // MARK: - Properties
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Init
    init(quoteServiceType: QuoteServiceType = QuoteService(networkManager: APIManager())) {
        self.quoteServiceType = quoteServiceType
    }

    // MARK: - API
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] event in
            switch event {
            case .viewDidAppear, .refreshButtonDidTapped: self?.setupRandomQuote()
            }
        }
        .store(in: &cancellables)
        return passthroughSubjectOutput.eraseToAnyPublisher()
    }

    // MARK: - Setups
    private func setupRandomQuote() {
        quoteServiceType.getRandomQuote().sink { [weak self] completion in
            if case .failure(let error) = completion {
                self?.passthroughSubjectOutput.send(.fetchQuoteDidFailed(error: error))
            }
        } receiveValue: { [weak self] quote in
            self?.passthroughSubjectOutput.send(.fetchQuoteDidSucceded(quote: quote))
        }
        .store(in: &cancellables)
    }
}

final class QuoteViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var refreshButton: UIButton!

    // MARK: - Constants
    private let quoteViewModel = QuoteViewModel()
    private let passthroughSubjectInput: PassthroughSubject<QuoteViewModel.Input, Never> = .init()

    // MARK: - Properties
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        bindSetup()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        passthroughSubjectInput.send(.viewDidAppear)
    }

    // MARK: - Setups
    private func bindSetup() {
        let output = quoteViewModel.transform(input: passthroughSubjectInput.eraseToAnyPublisher())
        output.sink { [weak self] event in
            DispatchQueue.main.async {
                switch event {
                case .fetchQuoteDidSucceded(let quote): self?.quoteLabel.text = quote.content
                case .fetchQuoteDidFailed(let error): self?.quoteLabel.text = error.localizedDescription
                case .toggleButton(let isEnabled): self?.refreshButton.isEnabled = isEnabled
                }
            }
        }
        .store(in: &cancellables)
    }

    // MARK: - Actions
    @IBAction func refreshButtonTapped(_ sender: Any) {
        passthroughSubjectInput.send(.refreshButtonDidTapped)
    }
}

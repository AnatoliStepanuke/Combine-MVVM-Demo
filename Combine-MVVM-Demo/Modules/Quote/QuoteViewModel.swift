import Foundation
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
        passthroughSubjectOutput.send(.toggleButton(isEnabled: false))
        quoteServiceType.getRandomQuote().sink { [weak self] completion in
            self?.passthroughSubjectOutput.send(.toggleButton(isEnabled: true))
            if case .failure(let error) = completion {
                self?.passthroughSubjectOutput.send(.fetchQuoteDidFailed(error: error))
            }
        } receiveValue: { [weak self] quote in
            self?.passthroughSubjectOutput.send(.fetchQuoteDidSucceded(quote: quote))
        }
        .store(in: &cancellables)
    }
}

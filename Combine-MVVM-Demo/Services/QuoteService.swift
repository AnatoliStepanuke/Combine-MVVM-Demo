import Combine

protocol QuoteServiceType {
    func getRandomQuote() -> AnyPublisher<Quote, Error>
}

final class QuoteService: QuoteServiceType {
    // MARK: - Constants
    private let networkManager: APIManager

    // MARK: - Init
    init(networkManager: APIManager) {
        self.networkManager = networkManager
    }

    // MARK: - API
    func getRandomQuote() -> AnyPublisher<Quote, Error> {
        return networkManager.getRandomQuote()
    }
}

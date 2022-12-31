import Foundation
import Combine

final class APIManager {
    // MARK: - API
    func getRandomQuote() -> AnyPublisher<Quote, Error> {
        guard let url = URL(string: Constants.quotesReference) else {
            return Result<Quote, Error>.failure(APIError.resultFailure).publisher.eraseToAnyPublisher()
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

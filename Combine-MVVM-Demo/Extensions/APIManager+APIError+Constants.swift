import Foundation

extension APIManager {
    enum APIError: Error { case resultFailure }
    enum Constants { static let quotesReference: String = "https://api.quotable.io/random" }
}

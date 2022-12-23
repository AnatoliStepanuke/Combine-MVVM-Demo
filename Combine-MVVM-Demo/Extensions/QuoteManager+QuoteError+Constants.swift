import Foundation

extension QuoteManager {
    enum QuoteError: Error { case resultFailure }
    enum Constants { static let quoteReference: String = "https://api.quotable.io/random" }
}

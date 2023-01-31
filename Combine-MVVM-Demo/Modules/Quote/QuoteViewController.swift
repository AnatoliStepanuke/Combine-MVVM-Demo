import UIKit
import Combine

final class QuoteViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
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
        output
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
            switch event {
            case .fetchQuoteDidSucceded(let quote):
                self?.quoteLabel.text = quote.content
                self?.authorLabel.text = quote.author
            case .fetchQuoteDidFailed(let error): self?.quoteLabel.text = error.localizedDescription
            case .toggleButton(let isEnabled): self?.refreshButton.isEnabled = isEnabled
            }
        }
        .store(in: &cancellables)
    }

    // MARK: - Actions
    @IBAction func refreshButtonTapped(_ sender: Any) {
        passthroughSubjectInput.send(.refreshButtonDidTapped)
    }

    @IBAction func toggleControllerButtonTapped(_ sender: Any) {
        if let toggleViewController = storyboard?.instantiateViewController(
            withIdentifier: "ToggleViewController"
        ) as? ToggleViewController {
//            let vm = CounterViewModel()
//            vc.viewModel = vm
            navigationController?.pushViewController(toggleViewController, animated: true)
        }
    }
}

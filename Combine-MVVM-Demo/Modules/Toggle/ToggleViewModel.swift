import Foundation
import Combine

final class ToggleViewModel {
    // MARK: - Constants
    private let passthroughSubjectOutput: PassthroughSubject<Output, Never> = .init()

    // MARK: - Properties
    private var cancellables = Set<AnyCancellable>()
    private var toggles: [Bool] = []
    private var toggleSwitchIsEnabled: Bool = false {
        didSet { toggles.append(toggleSwitchIsEnabled) }
    }
    private var text = "" {
        didSet { passthroughSubjectOutput.send(.toggleSwitchLabel(text: text)) }
    }

    // MARK: - Input
    enum Input {
        case toggleSwitchButtonIsEnabled
        case toggleSwitchButtonIsDisabled
    }

    // MARK: - Output
    enum Output {
        case toggleSwitchLabel(text: String)
        case toggleSwitchesAreEnabled(isEnabled: Bool)
    }

    // MARK: - API
    func handleToggleSwitchButtons(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] event in
            switch event {
            case .toggleSwitchButtonIsEnabled:
                self?.setupToggleSwitchButtonIsEnabled()
            case .toggleSwitchButtonIsDisabled:
                self?.setupToggleSwitchButtonIsDisabled()
            }
        }
        .store(in: &cancellables)
        return passthroughSubjectOutput.eraseToAnyPublisher()
    }

    // MARK: - Setups
    private func setupToggleSwitchButtonIsEnabled() {
        self.toggleSwitchIsEnabled = true
        if self.toggles == Constants.togglesForCompare {
            self.text = "All toggles are Enabled"
        }
    }

    private func setupToggleSwitchButtonIsDisabled() {
        self.text = ""
        self.toggleSwitchIsEnabled = false
        self.toggles.removeLast(2)
    }
}

// MARK: - Extensions
extension ToggleViewModel {
    enum Constants {
        static let togglesForCompare: [Bool] = [true, true, true, true, true]
    }
}

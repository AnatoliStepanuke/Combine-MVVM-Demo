import Foundation
import Combine

final class ToggleViewModel {
    // MARK: - Constants
    private let toggles2: [Bool] = [true, true, true, true, true]

    // MARK: - Properties
    private var cancellables = Set<AnyCancellable>()
    private var toggles: [Bool] = []
    private var toggleSwitchIsEnabled: Bool = false {
        didSet {
            toggles.append(toggleSwitchIsEnabled)
        }
    }
    private var text = "" {
        didSet {
            toggleSwitchLabel.send("\(text)")
        }
    }

    // MARK: - Input
    let toggleSwitchButtonIsEnabled = PassthroughSubject<Void, Never>()
    let toggleSwitchButtonIsDisabled = PassthroughSubject<Void, Never>()

    // MARK: - Output
    let toggleSwitchLabel = CurrentValueSubject<String, Never>("")
    let toggleSwitchesIsEnabled = CurrentValueSubject<Bool, Never>(false)

    // MARK: - Init
    init() {
        setupToggleSwitchButtonIsEnabled()
        setupToggleSwitchButtonIsDisabled()
    }

    // MARK: - API
    private func setupToggleSwitchButtonIsEnabled() {
        toggleSwitchButtonIsEnabled.sink { [weak self] in
            self?.toggleSwitchIsEnabled = true
            if self?.toggles == self?.toggles2 {
                self?.text = "All toggles are Enabled"
            }
        }
        .store(in: &cancellables)
    }

    private func setupToggleSwitchButtonIsDisabled() {
        toggleSwitchButtonIsDisabled.sink { [weak self] in
            self?.text = ""
            self?.toggleSwitchIsEnabled = false
            self?.toggles.removeLast(2)
        }
        .store(in: &cancellables)
    }

    // MARK: - Setups
}

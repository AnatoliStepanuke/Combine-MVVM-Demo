import UIKit
import Combine

final class ToggleViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var toggleLabel: UILabel!
    @IBOutlet weak var toggleButtonOne: UISwitch!
    @IBOutlet weak var toggleButtonTwo: UISwitch!
    @IBOutlet weak var toggleButtonThree: UISwitch!
    @IBOutlet weak var toggleButtonFour: UISwitch!
    @IBOutlet weak var toggleButtonFive: UISwitch!

    // MARK: - Constants
    private let toggleViewModel = ToggleViewModel()

    // MARK: - Properties
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
    }

    // MARK: - Setups
    private func setupBindings() {
        toggleViewModel.toggleSwitchLabel.sink(receiveValue: { [weak self] text in
            self?.toggleLabel.text = text
        })
        .store(in: &cancellables)
    }

    // MARK: - Actions
    @IBAction func toggleOne(_ sender: Any) { toggleButtonIsOn(toggleButton: toggleButtonOne) }
    @IBAction func toggleTwo(_ sender: Any) { toggleButtonIsOn(toggleButton: toggleButtonTwo) }
    @IBAction func toggleThree(_ sender: Any) { toggleButtonIsOn(toggleButton: toggleButtonThree) }
    @IBAction func toggleFour(_ sender: Any) { toggleButtonIsOn(toggleButton: toggleButtonFour) }
    @IBAction func toggleFive(_ sender: Any) { toggleButtonIsOn(toggleButton: toggleButtonFive) }
}

// MARK: - Extension
extension ToggleViewController {
    private func toggleButtonIsOn(toggleButton: UISwitch) {
        switch toggleButton.isOn {
        case true: toggleViewModel.toggleSwitchButtonIsEnabled.send()
        case false: toggleViewModel.toggleSwitchButtonIsDisabled.send()
        }
    }
}

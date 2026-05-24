import Foundation
import Observation
import Domain

@Observable
final class AddLocationViewModel {
    var name: String = ""
    var latitudeText: String = ""
    var longitudeText: String = ""

    @ObservationIgnored private let locationsUseCase: any LocationsUseCaseProtocol
    @ObservationIgnored private weak var coordinator: (any LocationsCoordinatorProtocol)?
    @ObservationIgnored private weak var delegate: (any AddLocationDelegate)?

    init(
        locationsUseCase: any LocationsUseCaseProtocol,
        coordinator: any LocationsCoordinatorProtocol,
        delegate: any AddLocationDelegate
    ) {
        self.locationsUseCase = locationsUseCase
        self.coordinator = coordinator
        self.delegate = delegate
    }

    var parsedLocation: Location? {
        guard let latitude = Double(latitudeText.replacingOccurrences(of: ",", with: ".")),
              let longitude = Double(longitudeText.replacingOccurrences(of: ",", with: ".")),
              (-90...90).contains(latitude),
              (-180...180).contains(longitude) else {
            return nil
        }
        return Location(name: name, latitude: latitude, longitude: longitude)
    }

    var isValid: Bool { parsedLocation != nil }

    func didTapSubmit() async {
        guard let location = parsedLocation else { return }
        await locationsUseCase.add(location)
        await delegate?.didAddLocation()
        coordinator?.dismissAddLocation()
    }

    func didTapCancel() {
        coordinator?.dismissAddLocation()
    }
}

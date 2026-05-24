import Foundation
import Observation
import DomainModels
import UseCases

@Observable
final class LocationsViewModel {
    enum State: Equatable {
        case idle
        case loading
        case loaded([LocationViewData])
        case failed(String)
    }

    private(set) var state: State = .idle

    @ObservationIgnored private let locationsUseCase: any LocationsUseCaseProtocol
    @ObservationIgnored private let wikipediaURLUseCase: any WikipediaPlacesURLUseCaseProtocol
    @ObservationIgnored private weak var coordinator: (any LocationsCoordinatorProtocol)?
    @ObservationIgnored private var loadTask: Task<Void, Never>?

    init(
        locationsUseCase: any LocationsUseCaseProtocol,
        wikipediaURLUseCase: any WikipediaPlacesURLUseCaseProtocol,
        coordinator: any LocationsCoordinatorProtocol
    ) {
        self.locationsUseCase = locationsUseCase
        self.wikipediaURLUseCase = wikipediaURLUseCase
        self.coordinator = coordinator
    }

    func load() async {
        loadTask?.cancel()
        let task = Task { [weak self] in
            guard let self else { return }
            state = .loading
            do {
                let locations = try await locationsUseCase.fetch()
                try Task.checkCancellation()
                state = .loaded(locations.map { $0.toViewData() })
            } catch is CancellationError {
                print("[LocationsViewModel] load cancelled by a newer call")
            } catch {
                state = .failed(error.localizedDescription)
            }
        }
        loadTask = task
        _ = await task.value
    }

    func didSelect(_ viewData: LocationViewData) {
        guard let url = wikipediaURLUseCase.build(for: viewData.asLocation) else { return }
        coordinator?.openURL(url)
    }

    func didTapAdd() {
        coordinator?.showAddLocation(delegate: self)
    }
}

extension LocationsViewModel: AddLocationDelegate {
    func didAddLocation() async {
        await load()
    }
}

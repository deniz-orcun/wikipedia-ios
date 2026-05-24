import Foundation
import DomainModels
import RepositoryProtocols

public protocol LocationsUseCaseProtocol: Sendable {
    /// The full list of available locations.
    func fetch() async throws -> [Location]

    /// Add a location to the store.
    func add(_ location: Location) async
}

package struct LocationsUseCase: LocationsUseCaseProtocol {
    private let repository: any LocationsRepositoryProtocol

    package init(repository: any LocationsRepositoryProtocol) {
        self.repository = repository
    }

    package func fetch() async throws -> [Location] {
        try await repository.fetchLocations()
    }

    package func add(_ location: Location) async {
        await repository.add(location)
    }
}

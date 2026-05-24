import Foundation
import UIKit
import Locations
import UseCases
import Repositories

@MainActor
final class DependencyContainer {

    private let locationsUseCase: any LocationsUseCaseProtocol
    private let wikipediaURLUseCase: any WikipediaPlacesURLUseCaseProtocol

    init() {
        let repository = RepositoryContainer.makeLocationsRepository()
        self.locationsUseCase = UseCaseContainer.makeLocationsUseCase(repository: repository)
        self.wikipediaURLUseCase = UseCaseContainer.makeWikipediaPlacesURLUseCase()
    }

    func locations(
        navigationController: UINavigationController,
        externalCoordinator: any ExternalLocationsCoordinatorProtocol
    ) -> some LocationsCoordinatorProtocol {
        LocationsContainer.makeCoordinator(
            navigationController: navigationController,
            externalCoordinator: externalCoordinator,
            locationsUseCase: locationsUseCase,
            wikipediaURLUseCase: wikipediaURLUseCase
        )
    }
}

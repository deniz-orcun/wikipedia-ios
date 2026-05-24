import Foundation
import UIKit
import UseCases
import RepositoryProtocols

public enum LocationsContainer {

    public static func makeCoordinator(
        navigationController: UINavigationController,
        externalCoordinator: any ExternalLocationsCoordinatorProtocol,
        locationsUseCase: any LocationsUseCaseProtocol,
        wikipediaURLUseCase: any WikipediaPlacesURLUseCaseProtocol
    ) -> some LocationsCoordinatorProtocol {
        LocationsCoordinator(
            navigationController: navigationController,
            externalCoordinator: externalCoordinator,
            locationsUseCase: locationsUseCase,
            wikipediaURLUseCase: wikipediaURLUseCase
        )
    }
}

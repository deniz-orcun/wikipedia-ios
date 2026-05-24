import Foundation

public enum DomainContainer {

    public static func makeLocationsUseCase(
        repository: any LocationsRepositoryProtocol
    ) -> any LocationsUseCaseProtocol {
        LocationsUseCase(repository: repository)
    }

    public static func makeWikipediaPlacesURLUseCase() -> some WikipediaPlacesURLUseCaseProtocol {
        WikipediaPlacesURLUseCase()
    }
}

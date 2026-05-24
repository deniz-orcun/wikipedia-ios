import DomainModels
import RepositoryProtocols

public enum UseCaseContainer {

    public static func makeLocationsUseCase(
        repository: any LocationsRepositoryProtocol
    ) -> any LocationsUseCaseProtocol {
        LocationsUseCase(repository: repository)
    }

    public static func makeWikipediaPlacesURLUseCase() -> some WikipediaPlacesURLUseCaseProtocol {
        WikipediaPlacesURLUseCase()
    }
}

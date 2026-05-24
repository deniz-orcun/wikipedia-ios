import Foundation
import RepositoryProtocols
import APIEndpoints

public enum RepositoryContainer {

    public static func makeLocationsRepository() -> some LocationsRepositoryProtocol {
        let apiClient = LocationsAPIClient(
            session: .shared,
            decoder: JSONDecoder()
        )
        return LocationsRepository(apiClient: apiClient)
    }
}

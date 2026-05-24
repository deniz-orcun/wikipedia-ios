import Foundation
import Domain

public enum DataContainer {

    public static func makeLocationsRepository() -> some LocationsRepositoryProtocol {
        let apiClient = LocationsAPIClient(
            session: .shared,
            decoder: JSONDecoder()
        )
        return LocationsRepository(apiClient: apiClient)
    }
}

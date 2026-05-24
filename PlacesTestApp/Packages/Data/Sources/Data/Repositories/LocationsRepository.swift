import Foundation
import Domain

package actor LocationsRepository: LocationsRepositoryProtocol {
    private let apiClient: any LocationsAPIClientProtocol
    private var cache: [Location] = []

    package init(apiClient: any LocationsAPIClientProtocol) {
        self.apiClient = apiClient
    }

    package func fetchLocations() async throws -> [Location] {
        if cache.isEmpty {
            cache = try await apiClient.fetchLocations().map { $0.toDomain() }
        }
        return cache
    }

    package func add(_ location: Location) {
        cache.append(location)
    }
}

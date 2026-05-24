import Foundation
import DomainModels

public protocol LocationsRepositoryProtocol: Sendable {
    /// The full list of available locations.
    func fetchLocations() async throws -> [Location]

    /// Add a location to the in-memory store.
    func add(_ location: Location) async
}

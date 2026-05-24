import Foundation

package protocol LocationsAPIClientProtocol: Sendable {
    /// Fetches the raw `LocationDataModel` payload from the locations endpoint.
    func fetchLocations() async throws -> [LocationDataModel]
}

package enum LocationsAPIError: LocalizedError, Equatable {
    case badResponse(status: Int)
    case decoding

    package var errorDescription: String? {
        switch self {
        case .badResponse(let status):
            return "Locations server responded with status \(status)."
        case .decoding:
            return "Locations response could not be read."
        }
    }
}

package struct LocationsAPIClient: LocationsAPIClientProtocol {
    private static let locationsURL = URL(
        string: "https://raw.githubusercontent.com/abnamrocoesd/assignment-ios/main/locations.json"
    )!

    private let session: URLSession
    private let decoder: JSONDecoder

    package init(session: URLSession, decoder: JSONDecoder) {
        self.session = session
        self.decoder = decoder
    }

    package func fetchLocations() async throws -> [LocationDataModel] {
        let (data, response) = try await session.data(from: Self.locationsURL)
        if let http = response as? HTTPURLResponse, !(200..<300).contains(http.statusCode) {
            throw LocationsAPIError.badResponse(status: http.statusCode)
        }
        do {
            return try decoder.decode(LocationsResponseDataModel.self, from: data).locations
        } catch {
            throw LocationsAPIError.decoding
        }
    }
}

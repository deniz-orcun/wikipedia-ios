import Foundation

public protocol WikipediaPlacesURLUseCaseProtocol: Sendable {
    /// The Wikipedia Places deep link for `location`, or `nil` when the coordinate is out of range.
    func build(for location: Location) -> URL?
}

package struct WikipediaPlacesURLUseCase: WikipediaPlacesURLUseCaseProtocol {

    package init() {}

    package func build(for location: Location) -> URL? {
        guard location.hasValidCoordinate else { return nil }

        var components = URLComponents()
        components.scheme = "wikipedia"
        components.host = "places"

        var queryItems = [
            URLQueryItem(name: "latitude", value: String(format: "%.6f", location.latitude)),
            URLQueryItem(name: "longitude", value: String(format: "%.6f", location.longitude))
        ]
        if let trimmed = location.name?.trimmingCharacters(in: .whitespacesAndNewlines),
           !trimmed.isEmpty {
            queryItems.append(URLQueryItem(name: "name", value: trimmed))
        }
        components.queryItems = queryItems

        return components.url
    }
}

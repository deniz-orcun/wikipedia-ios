import Foundation

public struct Location: Sendable, Equatable, Hashable {
    public let name: String?
    public let latitude: Double
    public let longitude: Double

    public init(name: String?, latitude: Double, longitude: Double) {
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
    }

    public var hasValidCoordinate: Bool {
        (-90...90).contains(latitude) && (-180...180).contains(longitude)
    }
}

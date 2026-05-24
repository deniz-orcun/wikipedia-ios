import Foundation

struct LocationViewData: Identifiable, Sendable, Equatable {
    var id: String { "\(latitude),\(longitude)" }
    let name: String?
    let latitude: Double
    let longitude: Double
    let displayName: String
    let coordinateText: String
}

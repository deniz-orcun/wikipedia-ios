import Foundation
import DomainModels

extension Location {
    func toViewData() -> LocationViewData {
        let trimmedName = name?.trimmingCharacters(in: .whitespacesAndNewlines)
        let coordinateText = String(format: "%.4f, %.4f", latitude, longitude)
        let displayName: String
        if let trimmedName, !trimmedName.isEmpty {
            displayName = trimmedName
        } else {
            displayName = coordinateText
        }
        return LocationViewData(
            name: name,
            latitude: latitude,
            longitude: longitude,
            displayName: displayName,
            coordinateText: coordinateText
        )
    }
}

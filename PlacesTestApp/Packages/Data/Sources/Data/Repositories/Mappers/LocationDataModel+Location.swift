import Foundation
import Domain

extension LocationDataModel {
    func toDomain() -> Location {
        Location(name: name, latitude: lat, longitude: long)
    }
}

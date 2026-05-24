import Foundation
import Domain

extension LocationViewData {
    var asLocation: Location {
        Location(name: name, latitude: latitude, longitude: longitude)
    }
}

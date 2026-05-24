import Foundation

package struct LocationsResponseDataModel: Decodable, Equatable {
    package let locations: [LocationDataModel]
}

package struct LocationDataModel: Decodable, Equatable {
    package let name: String?
    package let lat: Double
    package let long: Double
}

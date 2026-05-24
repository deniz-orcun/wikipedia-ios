import DomainModels
import DataModels

extension LocationDataModel {
    func toDomain() -> Location {
        Location(name: name, latitude: lat, longitude: long)
    }
}

import DomainModels

extension LocationViewData {
    var asLocation: Location {
        Location(name: name, latitude: latitude, longitude: longitude)
    }
}

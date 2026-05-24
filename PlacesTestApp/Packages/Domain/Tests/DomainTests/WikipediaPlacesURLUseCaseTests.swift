import Testing
import Foundation
import DomainModels
import UseCases

@Suite("WikipediaPlacesURLUseCase")
struct WikipediaPlacesURLUseCaseTests {
    let sut = WikipediaPlacesURLUseCase()

    @Test func buildsURLWithCoordinate() throws {
        let location = Location(name: nil, latitude: 52.379189, longitude: 4.899431)
        let url = try #require(sut.build(for: location))
        let components = try #require(URLComponents(url: url, resolvingAgainstBaseURL: false))

        #expect(components.scheme == "wikipedia")
        #expect(components.host == "places")

        let items = Dictionary(uniqueKeysWithValues: (components.queryItems ?? []).map { ($0.name, $0.value) })
        #expect(items["latitude"] == "52.379189")
        #expect(items["longitude"] == "4.899431")
        #expect(items["name"] == nil)
    }

    @Test func includesNameWhenProvided() throws {
        let url = try #require(
            sut.build(for: Location(name: "Amsterdam", latitude: 1, longitude: 2))
        )
        let items = URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems ?? []
        #expect(items.contains(URLQueryItem(name: "name", value: "Amsterdam")))
    }

    @Test func omitsBlankName() throws {
        let url = try #require(
            sut.build(for: Location(name: "   ", latitude: 1, longitude: 2))
        )
        let names = (URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems ?? []).map(\.name)
        #expect(!names.contains("name"))
    }

    @Test("Rejects out-of-range latitude", arguments: [91.0, -90.1])
    func rejectsOutOfRangeLatitude(_ latitude: Double) {
        #expect(sut.build(for: Location(name: nil, latitude: latitude, longitude: 0)) == nil)
    }

    @Test func rejectsOutOfRangeLongitude() {
        #expect(sut.build(for: Location(name: nil, latitude: 0, longitude: 181)) == nil)
    }

    @Test("Coordinates are formatted with a `.` regardless of device locale")
    func formatsCoordinateLocaleIndependently() throws {
        let url = try #require(
            sut.build(for: Location(name: nil, latitude: -33.8688, longitude: 151.2093))
        )
        let absolute = url.absoluteString
        #expect(absolute.contains("latitude=-33.868800"))
        #expect(absolute.contains("longitude=151.209300"))
        #expect(!absolute.contains(","))
    }
}

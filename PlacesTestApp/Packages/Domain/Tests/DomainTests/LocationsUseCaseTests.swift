import Testing
import Foundation
import Domain

@Suite("LocationsUseCase")
struct LocationsUseCaseTests {

    private actor StubRepository: LocationsRepositoryProtocol {
        var result: Result<[Location], any Error>
        var added: [Location] = []

        init(result: Result<[Location], any Error>) {
            self.result = result
        }

        func fetchLocations() async throws -> [Location] {
            try result.get()
        }

        func add(_ location: Location) {
            added.append(location)
        }
    }

    @Test func fetchReturnsRepositoryResults() async throws {
        let expected = [
            Location(name: "Amsterdam", latitude: 52.35, longitude: 4.83),
            Location(name: nil, latitude: 40.43, longitude: -3.74)
        ]
        let sut = LocationsUseCase(repository: StubRepository(result: .success(expected)))

        let actual = try await sut.fetch()

        #expect(actual == expected)
    }

    @Test func fetchPropagatesRepositoryError() async {
        struct Boom: Error, Equatable {}
        let sut = LocationsUseCase(repository: StubRepository(result: .failure(Boom())))

        await #expect(throws: Boom.self) {
            try await sut.fetch()
        }
    }

    @Test func addDelegatesToRepository() async {
        let repository = StubRepository(result: .success([]))
        let sut = LocationsUseCase(repository: repository)
        let location = Location(name: "X", latitude: 1, longitude: 2)

        await sut.add(location)

        let added = await repository.added
        #expect(added == [location])
    }
}

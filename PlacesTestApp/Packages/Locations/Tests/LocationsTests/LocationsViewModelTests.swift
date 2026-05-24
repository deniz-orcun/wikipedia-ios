import Testing
import Foundation
import Domain
@testable import Locations

private final class SpyCoordinator: LocationsCoordinatorProtocol {
    var openedURLs: [URL] = []
    var showAddLocationCount = 0
    var lastAddLocationDelegate: (any AddLocationDelegate)?
    var dismissAddLocationCount = 0

    func start() {}
    func openURL(_ url: URL) { openedURLs.append(url) }
    func showAddLocation(delegate: any AddLocationDelegate) {
        showAddLocationCount += 1
        lastAddLocationDelegate = delegate
    }
    func dismissAddLocation() { dismissAddLocationCount += 1 }
}

private actor StubLocationsUseCase: LocationsUseCaseProtocol {
    private let result: Result<[Location], any Error>

    init(result: Result<[Location], any Error>) {
        self.result = result
    }

    func fetch() async throws -> [Location] { try result.get() }
    func add(_ location: Location) {}
}

private struct StubWikipediaURLUseCase: WikipediaPlacesURLUseCaseProtocol {
    let url: URL?
    func build(for location: Location) -> URL? { url }
}

@Suite("LocationsViewModel")
struct LocationsViewModelTests {

    private func makeSUT(
        locations: [Location] = [],
        deepLink: URL? = URL(string: "wikipedia://places?latitude=1.000000&longitude=2.000000")
    ) -> (LocationsViewModel, SpyCoordinator) {
        let coordinator = SpyCoordinator()
        let viewModel = LocationsViewModel(
            locationsUseCase: StubLocationsUseCase(result: .success(locations)),
            wikipediaURLUseCase: StubWikipediaURLUseCase(url: deepLink),
            coordinator: coordinator
        )
        return (viewModel, coordinator)
    }

    @Test func startsIdle() {
        let (sut, _) = makeSUT()
        #expect(sut.state == .idle)
    }

    @Test func loadSuccessMapsToViewData() async {
        let domain = [
            Location(name: "Amsterdam", latitude: 52.35, longitude: 4.83),
            Location(name: nil, latitude: 40.43, longitude: -3.74)
        ]
        let (sut, _) = makeSUT(locations: domain)

        await sut.load()

        #expect(sut.state == .loaded(domain.map { $0.toViewData() }))
    }

    @Test func loadFailurePublishesFailedState() async {
        struct Boom: LocalizedError { var errorDescription: String? { "boom" } }
        let coordinator = SpyCoordinator()
        let sut = LocationsViewModel(
            locationsUseCase: StubLocationsUseCase(result: .failure(Boom())),
            wikipediaURLUseCase: StubWikipediaURLUseCase(url: nil),
            coordinator: coordinator
        )

        await sut.load()

        guard case .failed(let message) = sut.state else {
            Issue.record("Expected .failed, got \(sut.state)")
            return
        }
        #expect(message == "boom")
    }

    @Test func didSelectBuildsURLAndAsksCoordinatorToOpen() {
        let expectedURL = URL(string: "wikipedia://places?latitude=1.000000&longitude=2.000000")!
        let (sut, spy) = makeSUT(deepLink: expectedURL)
        let viewData = Location(name: "X", latitude: 1, longitude: 2).toViewData()

        sut.didSelect(viewData)

        #expect(spy.openedURLs == [expectedURL])
    }

    @Test func didSelectSkipsWhenUseCaseReturnsNil() {
        let (sut, spy) = makeSUT(deepLink: nil)
        let viewData = Location(name: "X", latitude: 1, longitude: 2).toViewData()

        sut.didSelect(viewData)

        #expect(spy.openedURLs.isEmpty)
    }

    @Test func didTapAddPassesSelfAsDelegate() {
        let (sut, spy) = makeSUT()

        sut.didTapAdd()

        #expect(spy.showAddLocationCount == 1)
        #expect(spy.lastAddLocationDelegate as AnyObject === sut)
    }

    @Test func didAddLocationTriggersReload() async {
        let initial = [Location(name: "A", latitude: 1, longitude: 1)]
        let (sut, _) = makeSUT(locations: initial)

        await sut.didAddLocation()

        #expect(sut.state == .loaded(initial.map { $0.toViewData() }))
    }
}

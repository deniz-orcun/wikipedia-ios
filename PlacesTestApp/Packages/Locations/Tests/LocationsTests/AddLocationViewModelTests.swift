import Testing
import Foundation
import Domain
@testable import Locations

private final class SpyCoordinator: LocationsCoordinatorProtocol {
    var openedURLs: [URL] = []
    var showAddLocationCount = 0
    var dismissAddLocationCount = 0

    func start() {}
    func openURL(_ url: URL) { openedURLs.append(url) }
    func showAddLocation(delegate: any AddLocationDelegate) { showAddLocationCount += 1 }
    func dismissAddLocation() { dismissAddLocationCount += 1 }
}

private final class SpyAddLocationDelegate: AddLocationDelegate {
    var didAddLocationCount = 0
    func didAddLocation() async { didAddLocationCount += 1 }
}

private actor StubLocationsUseCase: LocationsUseCaseProtocol {
    var added: [Location] = []

    func fetch() async throws -> [Location] { [] }
    func add(_ location: Location) { added.append(location) }
}

@Suite("AddLocationViewModel")
struct AddLocationViewModelTests {

    private func makeSUT() -> (
        AddLocationViewModel,
        SpyCoordinator,
        SpyAddLocationDelegate,
        StubLocationsUseCase
    ) {
        let coordinator = SpyCoordinator()
        let delegate = SpyAddLocationDelegate()
        let useCase = StubLocationsUseCase()
        let viewModel = AddLocationViewModel(
            locationsUseCase: useCase,
            coordinator: coordinator,
            delegate: delegate
        )
        return (viewModel, coordinator, delegate, useCase)
    }

    @Test func isInvalidWhenFieldsEmpty() {
        let (sut, _, _, _) = makeSUT()
        #expect(sut.isValid == false)
    }

    @Test func isValidWhenBothCoordinatesParseInRange() {
        let (sut, _, _, _) = makeSUT()
        sut.latitudeText = "52.379"
        sut.longitudeText = "4.899"
        #expect(sut.isValid == true)
    }

    @Test func acceptsCommaDecimalSeparator() {
        let (sut, _, _, _) = makeSUT()
        sut.latitudeText = "52,379"
        sut.longitudeText = "4,899"
        #expect(sut.isValid == true)
    }

    @Test func isInvalidWhenLatitudeOutOfRange() {
        let (sut, _, _, _) = makeSUT()
        sut.latitudeText = "91"
        sut.longitudeText = "0"
        #expect(sut.isValid == false)
    }

    @Test func isInvalidWhenLongitudeOutOfRange() {
        let (sut, _, _, _) = makeSUT()
        sut.latitudeText = "0"
        sut.longitudeText = "181"
        #expect(sut.isValid == false)
    }

    @Test func didTapSubmitAddsLocationNotifiesDelegateAndDismisses() async {
        let (sut, spy, delegate, useCase) = makeSUT()
        sut.name = "Amsterdam"
        sut.latitudeText = "52.379"
        sut.longitudeText = "4.899"

        await sut.didTapSubmit()

        let added = await useCase.added
        #expect(added == [Location(name: "Amsterdam", latitude: 52.379, longitude: 4.899)])
        #expect(delegate.didAddLocationCount == 1)
        #expect(spy.dismissAddLocationCount == 1)
    }

    @Test func didTapSubmitDoesNothingWhenInvalid() async {
        let (sut, spy, delegate, useCase) = makeSUT()
        sut.latitudeText = "abc"
        sut.longitudeText = "4.899"

        await sut.didTapSubmit()

        let added = await useCase.added
        #expect(added.isEmpty)
        #expect(delegate.didAddLocationCount == 0)
        #expect(spy.dismissAddLocationCount == 0)
    }

    @Test func didTapCancelDismissesWithoutNotifyingDelegate() {
        let (sut, spy, delegate, _) = makeSUT()
        sut.didTapCancel()
        #expect(spy.dismissAddLocationCount == 1)
        #expect(delegate.didAddLocationCount == 0)
    }
}

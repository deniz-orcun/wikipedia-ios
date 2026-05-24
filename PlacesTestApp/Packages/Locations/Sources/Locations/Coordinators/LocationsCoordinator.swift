import Foundation
import UIKit
import SwiftUI
import UseCases

public protocol AddLocationDelegate: AnyObject {
    /// Notified after a location is added through the add-location page.
    func didAddLocation() async
}

public protocol LocationsCoordinatorProtocol: AnyObject {
    /// Builds the root page and installs it on the navigation stack.
    func start()

    /// Open `url` outside the app.
    func openURL(_ url: URL)

    /// Present the add-location page modally; `delegate` is notified on submit.
    func showAddLocation(delegate: any AddLocationDelegate)

    /// Dismiss the currently presented add-location page.
    func dismissAddLocation()
}

public protocol ExternalLocationsCoordinatorProtocol: AnyObject {
    /// Open `url` outside the app. Returns `true` on success, `false` when no
    /// installed app can handle the URL.
    func locationsCoordinatorDidRequestOpen(_ url: URL) async -> Bool
}

final class LocationsCoordinator {
    private let navigationController: UINavigationController
    private weak var externalCoordinator: (any ExternalLocationsCoordinatorProtocol)?
    private let locationsUseCase: any LocationsUseCaseProtocol
    private let wikipediaURLUseCase: any WikipediaPlacesURLUseCaseProtocol
    private(set) var presentedAddLocationNavigationController: UINavigationController?

    init(
        navigationController: UINavigationController,
        externalCoordinator: any ExternalLocationsCoordinatorProtocol,
        locationsUseCase: any LocationsUseCaseProtocol,
        wikipediaURLUseCase: any WikipediaPlacesURLUseCaseProtocol
    ) {
        self.navigationController = navigationController
        self.externalCoordinator = externalCoordinator
        self.locationsUseCase = locationsUseCase
        self.wikipediaURLUseCase = wikipediaURLUseCase
    }
}

extension LocationsCoordinator: LocationsCoordinatorProtocol {

    func start() {
        let viewModel = LocationsViewModel(
            locationsUseCase: locationsUseCase,
            wikipediaURLUseCase: wikipediaURLUseCase,
            coordinator: self
        )
        let host = UIHostingController(rootView: LocationsListView(viewModel: viewModel))
        host.title = "Places"
        navigationController.setViewControllers([host], animated: false)
    }

    func openURL(_ url: URL) {
        Task { [weak self] in
            guard let self else { return }
            let opened = await externalCoordinator?.locationsCoordinatorDidRequestOpen(url) ?? false
            if !opened {
                presentURLOpenFailureAlert()
            }
        }
    }

    func showAddLocation(delegate: any AddLocationDelegate) {
        let viewModel = AddLocationViewModel(
            locationsUseCase: locationsUseCase,
            coordinator: self,
            delegate: delegate
        )
        let host = UIHostingController(rootView: AddLocationView(viewModel: viewModel))
        host.title = "Custom location"
        let nav = UINavigationController(rootViewController: host)
        presentedAddLocationNavigationController = nav
        navigationController.present(nav, animated: true)
    }

    func dismissAddLocation() {
        presentedAddLocationNavigationController?.dismiss(animated: true)
        presentedAddLocationNavigationController = nil
    }
}

private extension LocationsCoordinator {

    func presentURLOpenFailureAlert() {
        let alert = UIAlertController(
            title: "Couldn't open the link",
            message: "No app on this device can handle this link.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        topMostViewController().present(alert, animated: true)
    }

    func topMostViewController() -> UIViewController {
        var current: UIViewController = navigationController
        while let presented = current.presentedViewController {
            current = presented
        }
        return current
    }
}

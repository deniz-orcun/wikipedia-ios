import Foundation
import UIKit
import Locations

@MainActor
final class MainCoordinator {
    private let window: UIWindow
    private let rootNavigationController = UINavigationController()
    private let dependencies: DependencyContainer
    private var locationsCoordinator: (any LocationsCoordinatorProtocol)?

    init(window: UIWindow, dependencies: DependencyContainer) {
        self.window = window
        self.dependencies = dependencies
    }

    func start() {
        window.rootViewController = rootNavigationController
        window.makeKeyAndVisible()

        let locations = dependencies.locations(
            navigationController: rootNavigationController,
            externalCoordinator: self
        )
        self.locationsCoordinator = locations
        locations.start()
    }
}

extension MainCoordinator: ExternalLocationsCoordinatorProtocol {

    func locationsCoordinatorDidRequestOpen(_ url: URL) async -> Bool {
        await UIApplication.shared.open(url)
    }
}

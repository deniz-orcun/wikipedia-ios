// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "Domain",
    platforms: [.iOS(.v17)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(name: "DomainModels", targets: ["DomainModels"]),
        .library(name: "UseCases", targets: ["UseCases"]),
        .library(name: "RepositoryProtocols", targets: ["RepositoryProtocols"]),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "DomainModels"
        ),
        .target(
            name: "UseCases",
            dependencies: [
                "DomainModels",
                "RepositoryProtocols"
            ]
        ),
        .target(
            name: "RepositoryProtocols",
            dependencies: [
                "DomainModels"
            ]
        ),
        .testTarget(
            name: "DomainTests",
            dependencies: ["DomainModels", "UseCases", "RepositoryProtocols"]
        ),
    ],
)

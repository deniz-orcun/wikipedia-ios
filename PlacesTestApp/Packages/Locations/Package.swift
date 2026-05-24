// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "Locations",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "Locations", targets: ["Locations"])
    ],
    dependencies: [
        .package(path: "../Domain")
    ],
    targets: [
        .target(
            name: "Locations",
            dependencies: [
                .product(name: "DomainModels", package: "Domain"),
                .product(name: "UseCases", package: "Domain"),
            ],
            swiftSettings: [
                .defaultIsolation(MainActor.self)
            ]
        ),
        .testTarget(
            name: "LocationsTests",
            dependencies: [
                "Locations", 
                .product(name: "DomainModels", package: "Domain"),
                .product(name: "UseCases", package: "Domain"),
            ],
            swiftSettings: [
                .defaultIsolation(MainActor.self)
            ]
        )
    ]
)

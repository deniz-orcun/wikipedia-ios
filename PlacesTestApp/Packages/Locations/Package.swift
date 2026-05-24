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
            dependencies: ["Domain"],
            swiftSettings: [
                .defaultIsolation(MainActor.self)
            ]
        ),
        .testTarget(
            name: "LocationsTests",
            dependencies: ["Locations", "Domain"],
            swiftSettings: [
                .defaultIsolation(MainActor.self)
            ]
        )
    ]
)

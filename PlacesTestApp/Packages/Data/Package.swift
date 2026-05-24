// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "Data",
    platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "Repositories",
            targets: ["Repositories"]
        ),
    ],
    dependencies: [
        .package(path: "../Domain")
    ],
    targets: [
        .target(
            name: "DataModels"
        ),
        .target(
            name: "APIEndpoints",
            dependencies: [
                "DataModels",
            ]
        ),
        .target(
            name: "Repositories",
            dependencies: [
                "DataModels",
                "APIEndpoints",
                .product(name: "RepositoryProtocols", package: "Domain"),
                .product(name: "DomainModels", package: "Domain"),
            ]
        ),
    ]
)

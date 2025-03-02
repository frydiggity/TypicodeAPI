// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "Features",
    platforms: [.iOS(.v15), .macOS(.v15)],
    products: [
        .library(name: "Features", targets: ["Features"]),
    ],
    dependencies: [
        .package(path: "../Models"),
        .package(path: "../NetworkClient"),
        .package(url: "https://github.com/pointfreeco/swift-dependencies", from: "1.8.0"),
        .package(url: "https://github.com/pointfreeco/swift-perception", from: "1.5.1"),
    ],
    targets: [
        .target(
            name: "Features",
            dependencies: [
                .product(name: "Models", package: "Models"),
                .product(name: "NetworkClient", package: "NetworkClient"),
                .product(name: "Dependencies", package: "swift-dependencies"),
                .product(name: "Perception", package: "swift-perception"),
            ]
        ),
        .testTarget(
            name: "FeaturesTests",
            dependencies: [
                .target(name: "Features"),
            ]
        ),
    ]
)

// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "NetworkClient",
    platforms: [.iOS(.v15), .macOS(.v15)],
    products: [
        .library(name: "NetworkClient", targets: ["NetworkClient"]),
    ],
    dependencies: [
        .package(path: "../Models"),
        .package(url: "https://github.com/pointfreeco/swift-dependencies", from: "1.8.0"),
    ],
    targets: [
        .target(
            name: "NetworkClient",
            dependencies: [
                .product(name: "Models", package: "Models"),
                .product(name: "Dependencies", package: "swift-dependencies"),
                .product(name: "DependenciesMacros", package: "swift-dependencies"),
            ]
        ),
        .testTarget(
            name: "NetworkClientTests",
            dependencies: [
                .target(name: "NetworkClient"),
            ]
        ),
    ]
)

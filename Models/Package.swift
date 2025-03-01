// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "Models",
    platforms: [.iOS(.v15), .macOS(.v15)],
    products: [
        .library(name: "Models", targets: ["Models"]),
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-tagged", from: "0.6.0")
    ],
    targets: [
        .target(
            name: "Models",
            dependencies: [
                .product(name: "Tagged", package: "swift-tagged"),
            ]
        ),
        .testTarget(
            name: "ModelsTests",
            dependencies: [
                .target(name: "Models"),
            ]
        ),
    ]
)

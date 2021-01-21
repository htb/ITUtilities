// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "ITUtilities",
    platforms: [.iOS(.v10)],
    products: [
        .library(name: "ITUtilities", targets: ["ITUtilities"]),
    ],
    dependencies: [],
    targets: [
        .target(name: "ITUtilities", dependencies: []),
        .testTarget(name: "ITUtilitiesTests", dependencies: ["ITUtilities"]),
    ]
)

// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "ITUtilities",
    products: [
        .library(name: "ITUtilities", targets: ["ITUtilities"]),
    ],
    dependencies: [],
    targets: [
        .target(name: "ITUtilities", dependencies: []),
        .testTarget(name: "ITUtilitiesTests", dependencies: ["ITUtilities"]),
    ]
)

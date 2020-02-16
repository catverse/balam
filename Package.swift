// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "Balam",
    products: [
        .library(
            name: "Balam",
            targets: ["Balam"]),
    ],
    targets: [
        .target(
            name: "Balam",
            dependencies: []),
        .testTarget(
            name: "BalamTests",
            dependencies: ["Balam"]),
    ]
)

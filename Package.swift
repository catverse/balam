// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "Balam",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13),
        .watchOS(.v6)
    ],
    products: [
        .library(
            name: "Balam",
            targets: ["Balam"])
    ],
    targets: [
        .target(
            name: "Balam",
            path: "Sources"),
        .testTarget(
            name: "Tests",
            dependencies: ["Balam"],
            path: "Tests")
    ]
)

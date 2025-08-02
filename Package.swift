// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CellKit",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "CellKit",
            targets: ["CellKit"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "CellKit",
            dependencies: []),
        .testTarget(
            name: "CellKitTests",
            dependencies: ["CellKit"]),
    ]
)
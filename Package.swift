// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MetaCellKit",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "MetaCellKit",
            targets: ["MetaCellKit"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "MetaCellKit",
            dependencies: []),
        .testTarget(
            name: "MetaCellKitTests",
            dependencies: ["MetaCellKit"]),
    ]
)
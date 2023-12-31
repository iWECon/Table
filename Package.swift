// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Table",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Table",
            targets: ["Table"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/iWECon/Paginable", branch: "main")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "Table",
            dependencies: [
                "Paginable"
            ]
        ),
        .testTarget(
            name: "TableTests",
            dependencies: ["Table"]
        ),
    ]
)

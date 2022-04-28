// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "NetworkKit",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "NetworkKit",
            targets: ["NetworkKit"]),
    ],
    dependencies: [
        .package(path: "../Domain"),
        .package(url: "https://github.com/Quick/Nimble", from: "9.2.1")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "NetworkKit",
            dependencies: [
                "Domain"
            ]),
        .testTarget(
            name: "NetworkKitTests",
            dependencies: [
                "NetworkKit",
                "Nimble"
            ]),
    ]
)

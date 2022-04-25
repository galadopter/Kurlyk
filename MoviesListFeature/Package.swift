// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MoviesListFeature",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "MoviesListFeature",
            targets: ["MoviesListFeature"]),
    ],
    dependencies: [
        .package(path: "../DesignSystem"),
        .package(path: "../Domain"),
        .package(path: "../ComponentsKit"),
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "0.28.1")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "MoviesListFeature",
            dependencies: [
                "Domain",
                "DesignSystem",
                "ComponentsKit",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ]),
        .testTarget(
            name: "MoviesListFeatureTests",
            dependencies: [
                "MoviesListFeature",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ]),
    ]
)

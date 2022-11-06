// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MoviesListFeature",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v16)
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
        .package(path: "../SwiftGenPlugin"),
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "0.39.0"),
        .package(url: "https://github.com/Quick/Nimble", from: "9.2.1")
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
            ],
            exclude: ["Resources/swiftgen.yml"],
            resources: [
                .process("Resources")
            ],
            plugins: [
                .plugin(name: "SwiftGenPlugin", package: "SwiftGenPlugin")
            ]
        ),
        .testTarget(
            name: "MoviesListFeatureTests",
            dependencies: [
                "MoviesListFeature",
                "Nimble",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ]),
    ]
)

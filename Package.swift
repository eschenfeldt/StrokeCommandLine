// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "StrokeCommandLine",
    dependencies: [
        .package(url: "../StrokeModel", from: "0.1.2"),
        .package(url: "https://github.com/dmulholland/ArgParse.git", from:"0.1.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "StrokeCommandLine",
            dependencies: ["StrokeModel", "ArgParse"]
        )
    ]
)

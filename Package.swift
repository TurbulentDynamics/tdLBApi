// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "tdLBApi",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13)
    ],
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "tdLBApi",
            targets: ["Api"]),
        .library(
            name: "tdLBGeometry",
            targets: ["Geometry"]),
        .library(
            name: "tdLBQVecOutput",
            targets: ["QVecOutput"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        //        .package(url: "https://github.com/apple/swift-numerics", from: "0.0.5"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "Api",
            dependencies: ["QVecOutput"]),
        .target(
            name: "Geometry",
            dependencies: []),
        .target(
            name: "QVecOutput",
            dependencies: []),
        .testTarget(
            name: "ApiTests",
            dependencies: ["Api", "QVecOutput"]),
        .testTarget(
            name: "GeometryTests",
            dependencies: ["Geometry", "Api"]),
        .testTarget(
            name: "QVecOutputTests",
            dependencies: ["QVecOutput", "Api"])
    ]
)

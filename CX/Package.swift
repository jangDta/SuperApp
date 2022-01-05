// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CX",
    platforms: [.iOS(.v14)],
    products: [
        .library(
            name: "AppHome",
            targets: ["AppHome"]
        ),
    ],
    dependencies: [
        .package(name: "ModernRIBs", url: "https://github.com/DevYeom/ModernRIBs", .exact("1.0.1")),
        .package(path: "../Platform"),
        .package(path: "../Finance"),
        .package(path: "../Transport")
    ],
    targets: [
        .target(
            name: "AppHome",
            dependencies: [
                "ModernRIBs",
                .product(name: "TransportHome", package: "Transport"),
                .product(name: "FinanceRepository", package: "Finance"),
            ]
        ),
    ]
)

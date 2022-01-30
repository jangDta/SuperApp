// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Platform",
    platforms: [.iOS(.v14)],
    products: [
        .library(
            name: "CombineUtil",
            targets: ["CombineUtil"]
        ),
        .library(
            name: "FoundationUtil",
            targets: ["FoundationUtil"]
        ),
        .library(
            name: "RIBsUtil",
            targets: ["RIBsUtil"]
        ),
        .library(
            name: "UIUtil",
            targets: ["UIUtil"]
        ),
        .library(
            name: "DefaultsStore",
            targets: ["DefaultsStore"]
        ),
        .library(
            name: "Network",
            targets: ["Network"]
        ),
        .library(
            name: "NetworkImp",
            targets: ["NetworkImp"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/CombineCommunity/CombineExt", from: "1.0.0"),
        .package(name: "ModernRIBs", url: "https://github.com/DevYeom/ModernRIBs", .exact("1.0.1")),
        .package(url: "https://github.com/pointfreeco/combine-schedulers", from: "0.5.3"),
    ],
    targets: [
        .target(
            name: "CombineUtil",
            dependencies: [
                "CombineExt",
                .product(name: "CombineSchedulers", package: "combine-schedulers")
            ]
        ),
        .target(
            name: "FoundationUtil",
            dependencies: []
        ),
        .target(
            name: "RIBsUtil",
            dependencies: [
                "ModernRIBs"
            ]
        ),
        .target(
            name: "UIUtil",
            dependencies: [
                "RIBsUtil",
                "FoundationUtil"
            ]
        ),
        .target(
            name: "DefaultsStore",
            dependencies: []
        ),
        .target(
            name: "Network",
            dependencies: []
        ),
        .target(
            name: "NetworkImp",
            dependencies: [
                "Network"
            ]
        ),
    ]
)

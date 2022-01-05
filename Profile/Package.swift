// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Profile",
    platforms: [.iOS(.v14)],
    products: [
        .library(
            name: "ProfileHome",
            targets: ["ProfileHome"]
        ),
    ],
    dependencies: [
        .package(name: "ModernRIBs", url: "https://github.com/DevYeom/ModernRIBs", .exact("1.0.1")),
    ],
    targets: [
        .target(
            name: "ProfileHome",
            dependencies: [
                "ModernRIBs"
            ]
        ),
    ]
)

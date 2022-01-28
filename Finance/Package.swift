// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Finance",
    platforms: [.iOS(.v14)],
    products: [
        .library(
            name: "AddPaymentMethod",
            targets: ["AddPaymentMethod"]
        ),
        .library(
            name: "AddPaymentMethodImp",
            targets: ["AddPaymentMethodImp"]
        ),
        .library(
            name: "FinanceEntity",
            targets: ["FinanceEntity"]
        ),
        .library(
            name: "FinanceRepository",
            targets: ["FinanceRepository"]
        ),
        .library(
            name: "Topup",
            targets: ["Topup"]
        ),
        .library(
            name: "TopupImp",
            targets: ["TopupImp"]
        ),
        .library(
            name: "FinanceHome",
            targets: ["FinanceHome"]
        ),
        .library(
            name: "FinanceRepositoryTestSupport",
            targets: ["FinanceRepositoryTestSupport"]
        ),
    ],
    dependencies: [
        .package(name: "ModernRIBs", url: "https://github.com/DevYeom/ModernRIBs", .exact("1.0.1")),
        .package(path: "../Platform")
    ],
    targets: [
        .target(
            name: "AddPaymentMethod",
            dependencies: [
                "ModernRIBs",
                "FinanceEntity",
                .product(name: "RIBsUtil", package: "Platform")
            ]
        ),
        .target(
            name: "AddPaymentMethodImp",
            dependencies: [
                "ModernRIBs",
                "AddPaymentMethod",
                "FinanceEntity",
                "FinanceRepository",
                .product(name: "RIBsUtil", package: "Platform"),
                .product(name: "UIUtil", package: "Platform"),
                .product(name: "FoundationUtil", package: "Platform")
            ]
        ),
        .target(
            name: "Topup",
            dependencies: [
                "ModernRIBs"
            ]
        ),
        .target(
            name: "TopupImp",
            dependencies: [
                "ModernRIBs",
                "Topup",
                "FinanceEntity",
                "FinanceRepository",
                "AddPaymentMethod",
                .product(name: "RIBsUtil", package: "Platform"),
                .product(name: "UIUtil", package: "Platform"),
                .product(name: "FoundationUtil", package: "Platform")
            ]
        ),
        .target(
            name: "FinanceHome",
            dependencies: [
                "ModernRIBs",
                "FinanceEntity",
                "FinanceRepository",
                "AddPaymentMethod",
                "Topup",
                .product(name: "RIBsUtil", package: "Platform"),
                .product(name: "UIUtil", package: "Platform"),
                .product(name: "FoundationUtil", package: "Platform")
            ]
        ),
        .target(
            name: "FinanceEntity",
            dependencies: []
        ),
        .target(
            name: "FinanceRepository",
            dependencies: [
                "FinanceEntity",
                .product(name: "CombineUtil", package: "Platform"),
                .product(name: "Network", package: "Platform")
            ]
        ),
        .target(
            name: "FinanceRepositoryTestSupport",
            dependencies: [
                "FinanceEntity",
                "FinanceRepository",
                .product(name: "CombineUtil", package: "Platform")
            ]
        ),
        .testTarget(
            name: "TopupImpTests",
            dependencies: [
                "TopupImp",
                "FinanceEntity",
                "FinanceRepository",
                "FinanceRepositoryTestSupport"
            ]
        )
    ]
)

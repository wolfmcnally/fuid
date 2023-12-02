// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "FUID",
    products: [
        .library(
            name: "FUID",
            targets: ["FUID"]),
    ],
    dependencies: [
        .package(url: "https://github.com/wolfmcnally/swift-numberkit.git", .upToNextMajor(from: "2.4.3")),
        .package(url: "https://github.com/wolfmcnally/WolfBase.git", .upToNextMajor(from: "6.0.0")),
    ],
    targets: [
        .target(
            name: "FUID",
            dependencies: [
                "WolfBase",
                .product(name: "NumberKit", package: "swift-numberkit")
            ]),
        .testTarget(
            name: "FUIDTests",
            dependencies: [
                "FUID",
                "WolfBase"
            ]),
    ]
)
